# -*- coding: utf-8 -
import operator
from .local_time import get_now, TZ
from copy import deepcopy
from datetime import timedelta
from dateutil.parser import parse
from dpath.util import delete as xpathdelete, get as xpathget, new as xpathnew
from haversine import haversine
from json import load, loads
from jsonpath_rw import parse as parse_path
from munch import Munch, munchify, unmunchify
from robot.errors import ExecutionFailed
from robot.libraries.BuiltIn import BuiltIn
from robot.output import LOGGER
from robot.output.loggerhelper import Message
# These imports are not pointless. Robot's resource and testsuite files
# can access them by simply importing library "service_keywords".
# Please ignore the warning given by Flake8 or other linter.
from .initial_data import (
    create_fake_doc,
    create_fake_sentence,
    create_fake_amount,
    create_fake_amount_net,
    create_fake_amount_paid,
    create_fake_number,
    create_fake_number_float,
    create_fake_date,
    create_fake_funder,
    create_fake_period,
    get_fake_funder_scheme,
    fake,
    subtraction,
    field_with_id,
    test_bid_data,
    test_bid_value,
    test_bid_value_esco,
    test_bid_data_selection,
    test_bid_data_pq,
    test_change_data,
    test_claim_answer_data,
    test_claim_data,
    test_complaint_data,
    test_complaint_reply_data,
    test_confirm_data,
    test_feature_data,
    test_invalid_features_data,
    test_item_data,
    test_lot_data,
    test_lot_document_data,
    test_related_question,
    test_question_answer_data,
    test_question_data,
    test_supplier_data,
    test_tender_data,
    test_tender_data_competitive_dialogue,
    test_tender_data_limited,
    test_tender_data_openeu,
    test_tender_data_openua,
    test_tender_data_planning,
    test_tender_data_openua_defense,
    test_tender_data_framework_agreement,
    test_tender_data_pq,
    test_tender_data_selection,
    test_bid_competitive_data,
    test_monitoring_data,
    test_party,
    test_dialogue,
    test_conclusion,
    test_status_data,
    test_elimination_report,
    test_tender_data_esco,
    test_modification_data,
    test_agreement_change_data,
    create_fake_title,
    create_fake_value_amount,
    test_change_document_data,
    convert_amount,
    get_number_of_minutes,
    get_hash,
    invalid_INN_data,
    invalid_cost_data,
    invalid_gmdn_data,
    invalid_buyers_data,
    test_plan_cancel_data,
    test_confirm_plan_cancel_data,
    test_accept_complaint_data,
    test_reject_complaint_data,
    test_cancellation_data,
    test_cancel_pending_data,
    test_payment_data,
    test_24_hours_data,
    test_bid_competitive_data_stage_2,
    test_criteria_data,
    test_data_bid_criteria,
    test_bid_criteria,
    test_qualification_criteria,
    test_awards_criteria,
    test_tender_data_simple_defense,
    test_contract_criteria_response_data,
    test_criteria_guarantee_data,
    test_change_evidence_data,
    test_pricequotation_unsuccessfulReason_data,
    test_criteria_llc_data,
    test_price_change_data,
    test_price_change_lot_data,
    test_unit_price_amount,
    test_monitoring_proceed_number_data,
    test_monitoring_liability_data,
    log_webdriver_info,
    test_bid_value_stage1
)
from barbecue import chef
from restkit import request
# End of non-pointless import
import os
import re


NUM_TYPES = (int, long, float)
STR_TYPES = (str, unicode)


def get_current_tzdate():
    return get_now().strftime('%Y-%m-%d %H:%M:%S.%f')


def add_minutes_to_date(date, minutes):
    return (parse(date) + timedelta(minutes=float(minutes))).isoformat()


def compare_date(left, right, accuracy="minute", absolute_delta=True):
    '''Compares dates with specified accuracy

    Before comparison dates are parsed into datetime.datetime format
    and localized.

    :param left:            First date
    :param right:           Second date
    :param accuracy:        Max difference between dates to consider them equal
                            Default value   - "minute"
                            Possible values - "day", "hour", "minute" or float value
                            of seconds
    :param absolute_delta:  Type of comparison. If set to True, then no matter which date order. If set to
                            False then right must be lower then left for accuracy value.
                            Default value   - True
                            Possible values - True and False or something what can be casted into them
    :returns:               Boolean value

    :error:                 ValueError when there is problem with converting accuracy
                            into float value. When it will be catched warning will be
                            given and accuracy will be set to 60.

    '''
    left = parse(left)
    right = parse(right)

    if left.tzinfo is None:
        left = TZ.localize(left)
    if right.tzinfo is None:
        right = TZ.localize(right)

    delta = (left - right).total_seconds()

    if accuracy == "day":
        accuracy = 24 * 60 * 60 - 1
    elif accuracy == "hour":
        accuracy = 60 * 60 - 1
    elif accuracy == "minute":
        accuracy = 60 - 1
    else:
        try:
            accuracy = float(accuracy)
        except ValueError:
            LOGGER.log_message(Message("Could not convert from {} to float. Accuracy is set to 60 seconds.".format(accuracy), "WARN"))
            accuracy = 60
    if absolute_delta:
        delta = abs(delta)
    if delta > accuracy:
        return False
    return True


def compare_coordinates(left_lat, left_lon, right_lat, right_lon, accuracy=0.1):
    '''Compares coordinates with specified accuracy

    :param left_lat:        First coordinate latitude
    :param left_lon:        First coordinate longitude
    :param right_lat:       Second coordinate latitude
    :param right_lon:       Second coordinate longitude
    :param accuracy:        Max difference between coordinates to consider them equal
                            Default value   - 0.1
                            Possible values - float or integer value of kilometers

    :returns:               Boolean value

    :error:                 ValueError when there is problem with converting accuracy
                            into float value. When it will be catched warning will be
                            given and accuracy will be set to 0.1.
    '''
    for key, value in {'left_lat': left_lat, 'left_lon': left_lon, 'right_lat': right_lat, 'right_lon': right_lon}.iteritems():
        if not isinstance(value, NUM_TYPES):
            raise TypeError("Invalid type for coordinate '{0}'. "
                            "Expected one of {1}, got {2}".format(
                                key, str(NUM_TYPES), str(type(value))))
    distance = haversine((left_lat, left_lon), (right_lat, right_lon))
    if distance > accuracy:
        return False
    return True


def log_object_data(data, file_name=None, format="yaml", update=False, artifact=False):
    """Log object data in pretty format (JSON or YAML)

    Two output formats are supported: "yaml" and "json".

    If a file name is specified, the output is written into that file.

    If you would like to get similar output everywhere,
    use the following snippet somewhere in your code
    before actually using Munch. For instance,
    put it into your __init__.py, or, if you use zc.buildout,
    specify it in "initialization" setting of zc.recipe.egg.

    from munch import Munch
    Munch.__str__ = lambda self: Munch.toYAML(self, allow_unicode=True,
                                              default_flow_style=False)
    Munch.__repr__ = Munch.__str__
    """
    if not isinstance(data, Munch):
        data = munchify(data)
    if file_name:
        if artifact:
            file_path = os.path.join(os.path.dirname(__file__), 'data', file_name + '.' + format)
        else:
            output_dir = BuiltIn().get_variable_value("${OUTPUT_DIR}")
            file_path = os.path.join(output_dir, file_name + '.' + format)
        if update:
            try:
                with open(file_path, "r+") as file_obj:
                    new_data = data.copy()
                    data = munch_from_object(file_obj.read(), format)
                    data.update(new_data)
                    file_obj.seek(0)
                    file_obj.truncate()
            except IOError as e:
                LOGGER.log_message(Message(e, "INFO"))
                LOGGER.log_message(Message("Nothing to update, "
                                           "creating new file.", "INFO"))
        data_obj = munch_to_object(data, format)
        with open(file_path, "w") as file_obj:
            file_obj.write(data_obj)
    data_obj = munch_to_object(data, format)
    LOGGER.log_message(Message(data_obj.decode('utf-8'), "INFO"))


def munch_from_object(data, format="yaml"):
    if format.lower() == 'json':
        return Munch.fromJSON(data)
    else:
        return Munch.fromYAML(data)


def munch_to_object(data, format="yaml"):
    if format.lower() == 'json':
        return data.toJSON(indent=2)
    else:
        return data.toYAML(allow_unicode=True, default_flow_style=False)


def load_data_from(file_name, mode=None, external_params_name=None):
    """We assume that 'external_params' is a a valid json if passed
    """

    external_params = BuiltIn().\
        get_variable_value('${{{name}}}'.format(name=external_params_name))

    if not os.path.exists(file_name):
        file_name = os.path.join(os.path.dirname(__file__), 'data', file_name)
    with open(file_name) as file_obj:
        if file_name.endswith('.json'):
            file_data = Munch.fromDict(load(file_obj))
        elif file_name.endswith('.yaml'):
            file_data = Munch.fromYAML(file_obj)
    if mode == 'brokers':
        default = file_data.pop('Default')
        brokers = {}
        for k, v in file_data.iteritems():
            brokers[k] = merge_dicts(default, v)
        file_data = brokers

    try:
        ext_params_munch \
            = Munch.fromDict(loads(external_params)) \
            if external_params else Munch()
    except ValueError:
        raise ValueError(
            'Value {param} of command line parameter {name} is invalid'.
            format(name=external_params_name, param=str(external_params))
        )

    return merge_dicts(file_data, ext_params_munch)


def compute_intrs(brokers_data, used_brokers):
    """Compute optimal values for period intervals.

    Notice: This function is maximally effective if ``brokers_data``
    does not contain ``Default`` entry.
    Using `load_data_from` with ``mode='brokers'`` is recommended.
    """
    keys_to_prefer_lesser = ('accelerator',)

    def recur(l, r, prefer_greater_numbers=True):
        l, r = deepcopy(l), deepcopy(r)
        if isinstance(l, list) and isinstance(r, list) and len(l) == len(r):
            lst = []
            for ll, rr in zip(l, r):
                lst.append(recur(ll, rr))
            return lst
        elif isinstance(l, NUM_TYPES) and isinstance(r, NUM_TYPES):
            if l == r:
                return l
            if l > r:
                return l if prefer_greater_numbers else r
            if l < r:
                return r if prefer_greater_numbers else l
        elif isinstance(l, dict) and isinstance(r, dict):
            for k, v in r.iteritems():
                if k not in l.keys():
                    l[k] = v
                elif k in keys_to_prefer_lesser:
                   l[k] = recur(l[k], v, prefer_greater_numbers=False)
                else:
                    l[k] = recur(l[k], v)
            return l
        else:
            raise TypeError("Couldn't recur({0}, {1})".format(
                str(type(l)), str(type(r))))

    intrs = []
    for i in used_brokers:
        intrs.append(brokers_data[i]['intervals'])
    result = intrs.pop(0)
    for i in intrs:
        result = recur(result, i)
    return result


def prepare_test_tender_data(procedure_intervals,
                             tender_parameters,
                             submissionMethodDetails,
                             accelerator,
                             funders,
                             plan_data):
    # Get actual intervals by mode name
    mode = tender_parameters['mode']
    if mode in procedure_intervals:
        intervals = procedure_intervals[mode]
    else:
        intervals = procedure_intervals['default']
    LOGGER.log_message(Message(intervals))
    tender_parameters['intervals'] = intervals

    # Set acceleration value for certain modes
    assert isinstance(intervals['accelerator'], int), \
        "Accelerator should be an 'int', " \
        "not '{}'".format(type(intervals['accelerator']).__name__)
    assert intervals['accelerator'] >= 0, \
        "Accelerator should not be less than 0"
    if mode == 'negotiation':
        return munchify({'data': test_tender_data_limited(tender_parameters, plan_data)})
    elif mode == 'negotiation.quick':
        return munchify({'data': test_tender_data_limited(tender_parameters, plan_data)})
    elif mode == 'openeu':
        return munchify({'data': test_tender_data_openeu(
            tender_parameters, submissionMethodDetails, plan_data)})
    elif mode == 'openua':
        return munchify({'data': test_tender_data_openua(
            tender_parameters, submissionMethodDetails, plan_data)})
    elif mode == 'openua_defense':
        return munchify({'data': test_tender_data_openua_defense(
            tender_parameters, submissionMethodDetails, plan_data)})
    elif mode == 'open_competitive_dialogue':
        return munchify({'data': test_tender_data_competitive_dialogue(
            tender_parameters, submissionMethodDetails, plan_data)})
    elif mode == 'reporting':
        return munchify({'data': test_tender_data_limited(tender_parameters, plan_data)})
    elif mode == 'open_framework':
        return munchify({'data': test_tender_data_framework_agreement(
            tender_parameters, submissionMethodDetails, plan_data)})
    elif mode == 'belowThreshold':
        return munchify({'data': test_tender_data(
            tender_parameters,
            plan_data,
            submissionMethodDetails=submissionMethodDetails,
            funders=funders,
            accelerator=accelerator,
            )})
    elif mode == 'open_esco':
        return munchify({'data': test_tender_data_esco(
            tender_parameters, submissionMethodDetails, plan_data)})
    elif mode == 'priceQuotation':
        return munchify({'data': test_tender_data_pq(tender_parameters, submissionMethodDetails, plan_data)})
    elif mode == "open_simple_defense":
        return munchify({'data': test_tender_data_simple_defense(
            tender_parameters, submissionMethodDetails, plan_data)})

        # The previous line needs an explicit keyword argument because,
        # unlike previous functions, this one has three arguments.
    raise ValueError("Invalid mode for prepare_test_tender_data")


def run_keyword_and_ignore_keyword_definitions(name, *args, **kwargs):
    """This keyword is pretty similar to `Run Keyword And Ignore Error`,
    which, unfortunately, does not suppress the error when you try
    to use it to run a keyword which is not defined.
    As a result, the execution of its parent keyword / test case is aborted.

    How this works:

    This is a simple wrapper for `Run Keyword And Ignore Error`.
    It handles the error mentioned above and additionally provides
    a meaningful error message.
    """
    try:
        status, _ = BuiltIn().run_keyword_and_ignore_error(name, *args, **kwargs)
    except ExecutionFailed as e:
        status, _ = "FAIL", e.message
    return status, _


def set_access_key(tender, access_token):
    tender.access = munchify({"token": access_token})
    return tender


def get_from_object(obj, path):
    """Gets data from a dictionary using a dotted accessor-string"""
    jsonpath_expr = parse_path(path)
    return_list = [i.value for i in jsonpath_expr.find(obj)]
    if return_list:
        return return_list[0]
    else:
        raise AttributeError('Attribute not found: {0}'.format(path))


def set_to_object(obj, path, value):
    def recur(obj, path, value):
        if not isinstance(obj, dict):
            raise TypeError('expected %s, got %s' %
                            (dict.__name__, type(obj)))

        # Search the list index in path to value
        groups = re.search(r'^(?P<key>[0-9a-zA-Z_]+)(?:\[(?P<index>-?\d+)\])?'
                           '(?:\.(?P<suffix>.+))?$', path)

        err = RuntimeError('could not parse the path: ' + path)
        if not groups:
            raise err

        gd = {k: v for k, v in groups.groupdict().items() if v is not None}
        is_list = False
        suffix = None

        if 'key' not in gd:
            raise err
        key = gd['key']

        if 'index' in gd:
            is_list = True
            index = int(gd['index'])

        if 'suffix' in gd:
            suffix = gd['suffix']

        if is_list:
            if key not in obj:
                obj[key] = []
            elif not isinstance(obj[key], list):
                raise TypeError('expected %s, got %s' %
                                (list.__name__, type(obj[key])))

            plusone = 1 if index >= 0 else 0
            if len(obj[key]) < abs(index) + plusone:
                while not len(obj[key]) == abs(index) + plusone:
                    extension = [None] * (abs(index) + plusone - len(obj[key]))
                    if index < 0:
                        obj[key] = extension + obj[key]
                    else:
                        obj[key].extend(extension)
                if suffix:
                    obj[key][index] = {}
            if suffix:
                obj[key][index] = recur(obj[key][index], suffix, value)
            else:
                obj[key][index] = value
        else:
            if key not in obj:
                obj[key] = {}
            if suffix:
                obj[key] = recur(obj[key], suffix, value)
            else:
                obj[key] = value

        return obj

    if not isinstance(path, STR_TYPES):
        raise TypeError('Path must be one of ' + str(STR_TYPES))
    return munchify(recur(obj, path, value))


def wait_to_date(date_stamp):
    date = parse(date_stamp)
    LOGGER.log_message(Message("date: {}".format(date.isoformat()), "INFO"))
    now = get_now()
    LOGGER.log_message(Message("now: {}".format(now.isoformat()), "INFO"))
    wait_seconds = (date - now).total_seconds()
    wait_seconds += 2
    if wait_seconds < 0:
        return 0
    return wait_seconds


def merge_dicts(a, b):
    """Merge dicts recursively.

    Origin: https://www.xormedia.com/recursively-merge-dictionaries-in-python/
    """
    if not isinstance(b, dict):
        return b
    result = deepcopy(a)
    for k, v in b.iteritems():
        if k in result and isinstance(result[k], dict):
                result[k] = merge_dicts(result[k], v)
        else:
            result[k] = deepcopy(v)
    return munchify(result)


def create_data_dict(path_to_value=None, value=None):
    """Create a dictionary with one key, 'data'.

    If `path_to_value` is not given, set the key's value
    to an empty dictionary.
    If `path_to_value` is given, set the key's value to `value`.
    In case it's the latter and if `value` is not set,
    the key's value is set to `None`.

    Please note that `path_to_value` is relative to the parent dictionary,
    thus, you may need to prepend `data.` to your path string.

    To better understand how `path_to_value` is handled,
    please refer to the `set_to_object()` function.
    """
    data_dict = {'data': {}}
    if path_to_value:
        data_dict = set_to_object(data_dict, path_to_value, value)
    return data_dict


def munch_dict(arg=None, data=False):
    if arg is None:
        arg = {}
    if data:
        arg['data'] = {}
    return munchify(arg)


def get_id_from_object(obj):
    regex = r'(^[filq]-[0-9a-fA-F]{8}): '

    title = obj.get('title', '')
    if title:
        if not isinstance(title, STR_TYPES):
            raise TypeError('title must be one of %s' % str(STR_TYPES))
        obj_id = re.match(regex, title)
        if obj_id and len(obj_id.groups()) >= 1:
            return obj_id.group(1)

    description = obj.get('description', '')
    if description:
        if not isinstance(description, STR_TYPES):
            raise TypeError('description must be one of %s' % str(STR_TYPES))
        obj_id = re.match(regex, description)
        if obj_id and len(obj_id.groups()) >= 1:
            return obj_id.group(1)

    raise ValueError('could not find object ID in "title": "%s", '
                    '"description": "%s"' % (title, description))


def get_id_from_string(string):
    return re.match(r'[dc]\-[0-9a-fA-F]{8}', string).group(0)


def get_object_type_by_id(object_id):
    prefixes = {'q': 'questions', 'f': 'features', 'i': 'items', 'l': 'lots'}
    return prefixes.get(object_id[0])


def get_complaint_index_by_complaintID(data, complaintID):
    if not data:
        return 0
    for index, element in enumerate(data):
        if element['complaintID'] == complaintID:
            break
    else:
        index += 1
    return index


def get_object_index_by_id(data, object_id):
    if not data:
        return 0
    for index, element in enumerate(data):
        element_id = get_id_from_object(element)
        if element_id == object_id:
            break
    else:
        index += 1
    return index


def get_object_by_id(data, given_object_id, slice_element, object_id):
    """
        data: object to slice
        given_object_id: with what id we should compare
        slice_element: what path should be extracted (e.g. from { key: val } extract key )
        object_id: what property is id (e.g. from { id: 1, name: 2 } extract id)
    """

    # Slice the given object, e.g. slice bid object to lotValues object
    try:
        sliced_object = data[slice_element]
    except KeyError:
        return data

    # If there is one sliced object, get the 1st element
    if len(sliced_object) == 1:
        return sliced_object[0]

    # Compare given object id and id from sliced object
    for index, element in enumerate(sliced_object):
        element_id = element[object_id]
        if element_id == given_object_id:
            return element

    return sliced_object[0]


def generate_test_bid_data(tender_data, edrpou=None):
    if tender_data.get('procurementMethodType', '') in ('aboveThresholdUA', 'aboveThresholdEU', 'closeFrameworkAgreementUA'):
        bid = test_bid_competitive_data()
        bid.data.selfQualified = True
        if 'lots' in tender_data:
            bid.data.lotValues = []
            for lot in tender_data['lots']:
                value = test_bid_value(lot['value']['amount'], lot['value']['valueAddedTaxIncluded'])
                value['relatedLot'] = lot.get('id', '')
                bid.data.lotValues.append(value)
        else:
            bid.data.update(test_bid_value(tender_data['value']['amount'], tender_data['value']['valueAddedTaxIncluded']))
        if 'features' in tender_data:
            bid.data.parameters = []
            for feature in tender_data['features']:
                parameter = {"value": fake.random_element(elements=(0.05, 0.01, 0)), "code": feature.get('code', '')}
                bid.data.parameters.append(parameter)
    elif tender_data.get('procurementMethodType', '') == 'esco':
        bid = test_bid_competitive_data()
        bid.data.selfQualified = True
        if 'lots' in tender_data:
            bid.data.lotValues = []
            for lot in tender_data['lots']:
                    value = test_bid_value_esco(tender_data)
                    value['relatedLot'] = lot.get('id', '')
                    bid.data.lotValues.append(value)
        else:
            value = test_bid_value(tender_data)
            bid.data.update(value)
        if 'features' in tender_data:
            bid.data.parameters = []
            for feature in tender_data['features']:
                parameter = {"value": fake.random_element(elements=(0.05, 0.01, 0)), "code": feature.get('code', '')}
                bid.data.parameters.append(parameter)
    elif tender_data.get('procurementMethodType', '') in ('competitiveDialogueUA', 'competitiveDialogueEU'):
        bid = test_bid_competitive_data()
        bid.data.selfQualified = True
        if 'lots' in tender_data:
            bid.data.lotValues = []
            for lot in tender_data['lots']:
                relatedLot = lot.get('id', '')
                value = test_bid_value_stage1(relatedLot)
                bid.data.lotValues.append(value)
    elif tender_data.get('procurementMethodType', '') == 'simple.defense':
        bid = test_bid_competitive_data()
        bid.data.selfEligible = True
        bid.data.selfQualified = True
        if 'lots' in tender_data:
            bid.data.lotValues = []
            for lot in tender_data['lots']:
                value = test_bid_value(lot['value']['amount'], lot['value']['valueAddedTaxIncluded'])
                value['relatedLot'] = lot.get('id', '')
                bid.data.lotValues.append(value)
        else:
            bid.data.update(test_bid_value(tender_data['value']['amount'], tender_data['value']['valueAddedTaxIncluded']))
        if 'features' in tender_data:
            bid.data.parameters = []
            for feature in tender_data['features']:
                parameter = {"value": fake.random_element(elements=(0.05, 0.01, 0)), "code": feature.get('code', '')}
                bid.data.parameters.append(parameter)
    elif tender_data.get('procurementMethodType', '') in ('competitiveDialogueUA.stage2', 'competitiveDialogueEU.stage2'):
        bid = test_bid_competitive_data_stage_2(edrpou)
        bid.data.selfQualified = True
        if 'lots' in tender_data:
            bid.data.lotValues = []
            for lot in tender_data['lots']:
                value = test_bid_value(lot['value']['amount'], lot['value']['valueAddedTaxIncluded'])
                value['relatedLot'] = lot.get('id', '')
                bid.data.lotValues.append(value)
        else:
            bid.data.update(test_bid_value(tender_data['value']['amount'], tender_data['value']['valueAddedTaxIncluded']))
        if 'features' in tender_data:
            bid.data.parameters = []
            for feature in tender_data['features']:
                parameter = {"value": fake.random_element(elements=(0.05, 0.01, 0)), "code": feature.get('code', '')}
                bid.data.parameters.append(parameter)
    else:
        bid = test_bid_data()
        if 'lots' in tender_data:
            bid.data.lotValues = []
            for lot in tender_data['lots']:
                value = test_bid_value(lot['value']['amount'], lot['value']['valueAddedTaxIncluded'])
                value['relatedLot'] = lot.get('id', '')
                bid.data.lotValues.append(value)
        else:
            bid.data.update(test_bid_value(tender_data['value']['amount'], tender_data['value']['valueAddedTaxIncluded']))
        if 'features' in tender_data:
            bid.data.parameters = []
            for feature in tender_data['features']:
                parameter = {"value": fake.random_element(elements=(0.05, 0.01, 0)), "code": feature.get('code', '')}
                bid.data.parameters.append(parameter)
    return bid


def mult_and_round(*args, **kwargs):
    return round(reduce(operator.mul, args), kwargs.get('precision', 2))


def convert_amount_string_to_float(amount_string):
    return float(amount_string.replace(' ', '').replace(',', '.'))


def compare_rationale_types(type1, type2):
    return set(type1) == set(type2)


def delete_from_dictionary(variable, path):
    if not type(path) in STR_TYPES:
        raise TypeError('path must be one of: ' +
            str(STR_TYPES))
    return xpathdelete(variable, path, separator='.')


def dictionary_should_not_contain_path(dictionary, path):
    try:
        xpathget(dictionary, path, separator='.')
    except KeyError:
        return
    raise RuntimeError("Dictionary contains path '%s'." % path)


def edit_tender_data_for_mnn(data, mode, data_version):
    id = {1: '33600000-6', 2: '33632100-0', 3: '33632100-0', 4: '33622200-8', 5: '33600000-6', 6: '33692500-2', 7: '33600000-6', 8: '33615100-5'}
    dict_data = unmunchify(data)
    dict_data['data']['items'][0]['classification']['id'] = id[data_version]
    if data_version is 3:
        dict_data['data']['items'][0].pop('additionalClassifications', None)
    if data_version is 4:
        add_INN = invalid_INN_data()
        dict_data['data']['items'][0]['additionalClassifications'].append(add_INN)
    if data_version is 5:
        dict_data['data']['items'][0].pop('additionalClassifications', None)
    if data_version is 6:
        dict_data['data']['items'][0]['additionalClassifications'].pop(0)
    if data_version is 7:
        dict_data['data']['items'][0]['additionalClassifications'].pop(1)
    if data_version is 8:
        dict_data['data']['items'][0]['additionalClassifications'].pop(1)
    return munchify(dict_data)


def edit_tender_data_for_cost(data, mode, data_version):
    test_data = {3: 'PQ-17', 4: 'Дорога'}
    dict_data = unmunchify(data)
    if data_version is 1:
        dict_data['data']['items'][0].pop('additionalClassifications', None)
    if data_version is 2:
        add_cost = invalid_cost_data()
        dict_data['data']['items'][0]['additionalClassifications'].append(add_cost)
    if data_version is 3:
        dict_data['data']['items'][0]['additionalClassifications'][0]['id'] = test_data[data_version]
    if data_version is 4:
        dict_data['data']['items'][0]['additionalClassifications'][0]['description'] = test_data[data_version]
    if data_version is 5:
        add_cost = invalid_cost_data()
        dict_data['data']['items'][0]['additionalClassifications'][0] = add_cost
    return munchify(dict_data)


def edit_tender_data_for_gmdn(data, mode, data_version):
    gmdn_test_data = {3: '9999', 4: 'Виріб'}
    dict_data = unmunchify(data)
    if data_version is 1:
        dict_data['data']['items'][0].pop('additionalClassifications', None)
    if data_version is 2:
        add_gmdn = invalid_gmdn_data()
        dict_data['data']['items'][0]['additionalClassifications'].append(add_gmdn)
    if data_version is 3:
        dict_data['data']['items'][0]['additionalClassifications'][0]['id'] = gmdn_test_data[data_version]
    if data_version is 4:
        dict_data['data']['items'][0]['additionalClassifications'][0]['description'] = gmdn_test_data[data_version]
    if data_version is 5:
        add_gmdn = invalid_gmdn_data()
        dict_data['data']['items'][0]['additionalClassifications'][0] = add_gmdn
    if data_version is 6:
        add_INN = invalid_INN_data()
        dict_data['data']['items'][0]['additionalClassifications'].append(add_INN)
    return munchify(dict_data)


def edit_plan_buyers(data, data_version):
    dict_data = unmunchify(data)
    if data_version is 1:
        add_buyer = invalid_buyers_data()
        dict_data['data']['buyers'].append(add_buyer)
    if data_version is 2:
        dict_data['data'].pop('buyers')
    return munchify(dict_data)


def edit_tender_data_for_plan_tender(data, mode, data_version):
    plan_tedner_test_data = {1: '03222111-4', 2: 'UA-FIN', 3: '11112222', 4: 'aboveThresholdEU'}
    dict_data = unmunchify(data)
    if data_version is 1:
        dict_data['data']['items'][0]['classification']['id'] = plan_tedner_test_data[data_version]
    if data_version is 2:
        dict_data['data']['procuringEntity']['identifier']['scheme'] = plan_tedner_test_data[data_version]
    if data_version is 3:
        dict_data['data']['procuringEntity']['identifier']['id'] = plan_tedner_test_data[data_version]
    if data_version is 4:
        dict_data['data']['procurementMethodType'] = plan_tedner_test_data[data_version]
    return munchify(dict_data)


def get_lowest_value_from_list(list_value):
    return min(list_value)
