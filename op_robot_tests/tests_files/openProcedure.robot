*** Settings ***
Resource        base_keywords.robot
Resource        aboveThreshold_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown


*** Variables ***
${MODE}             openeu
@{USED_ROLES}       tender_owner  provider  provider1  provider2  viewer
${DIALOGUE_TYPE}    EU

${NUMBER_OF_ITEMS}  ${1}
${NUMBER_OF_LOTS}   ${1}
${NUMBER_OF_MILESTONES}  ${3}
${TENDER_MEAT}      ${True}
${LOT_MEAT}         ${True}
${ITEM_MEAT}        ${True}
${MOZ_INTEGRATION}  ${False}
${VAT_INCLUDED}     ${True}
${ROAD_INDEX}       ${False}
${GMDN_INDEX}       ${False}
${PLAN_TENDER}      ${True}
${BID_AMOUNT_1}     ${500}
${BID_AMOUNT_2}     ${1000}
${BID_AMOUNT_3}     ${1100}
${ARTICLE_17}       ${False}
${CRITERIA_GUARANTEE}  ${False}
${CRITERIA_LOT}     ${False}
${CRITERIA_LLC}     ${False}

*** Test Cases ***
Можливість оголосити тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер


Можливість оголосити тендер на закупівлю фармацевтичної продукції
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_mnn_1  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер з використанням валідації для MNN  ${1}


Можливість оголосити тендер на лікарських засобів
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_mnn_2  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер з використанням валідації для MNN  ${2}


Можливість оголосити тендер на лікарських засобів без додаткового класифікатора
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_mnn_3  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер з використанням валідації для MNN  ${3}


Неможливість опублікувати тендер на закупівлю лікарських засобів з двома значеннями МНН
    [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_invalid_2_INN  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword And Expect Error  *  Можливість оголосити тендер з використанням валідації для MNN  ${4}


Неможливість опублікувати тендер на закупівлю фармацевтичної продукції з відсутнім додатковим класифікатором
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_invalid_no_add_class  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword And Expect Error  *  Можливість оголосити тендер з використанням валідації для MNN  ${5}


Опублікувати тендер на закупівлю лікарських засобів без коду МНН
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_invalid_no_INN  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер з використанням валідації для MNN  ${6}


Опублікувати тендер на закупівлю фармацевтичної продукції без коду АТХ
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_invalid_no_atc  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер з використанням валідації для MNN  ${7}


Опублікувати тендер на закупівлю лікарських засобів без коду АТХ
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_invalid_no_atc_2  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер з використанням валідації для MNN  ${8}


Опублікувати тендер на закупівлю дорожніх робіт без додаткового класифікатора
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_cost_no_addclass  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер з використанням валідації Індекс автомобільних доріг  ${1}


Неможливість опублікувати тендер на закупівлю дорожніх робіт з 2-ма додатковими класифікаторами
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_cost_2_addclass  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword And Expect Error  *  Можливість оголосити тендер з використанням валідації Індекс автомобільних доріг  ${2}


Неможливість опублікувати тендер на закупівлю дорожніх робіт з невалідним id дороги
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_cost_invalid_addclass_id  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword And Expect Error  *  Можливість оголосити тендер з використанням валідації Індекс автомобільних доріг  ${3}


Неможливість опублікувати тендер на закупівлю дорожніх робіт з невалідним description дороги
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_cost_invalid_addclass_description  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword And Expect Error  *  Можливість оголосити тендер з використанням валідації Індекс автомобільних доріг  ${4}


Неможливість опублікувати тендер cpv не відповідає додатковому класифікатору UA-ROAD
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_cost_invalid_addclass  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword And Expect Error  *  Можливість оголосити тендер з використанням валідації Індекс автомобільних доріг  ${5}


Опублікувати тендер на закупівлю медичних виробів без додаткового класифікатора
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_gmdn_no_addclass  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер з використанням валідації класифікатор медичних виробів  ${1}


Неможливість опублікувати на закупівлю медичних виробів з 2-ма додатковими класифікаторами
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_gmdn_2_addclass  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword And Expect Error  *  Можливість оголосити тендер з використанням валідації класифікатор медичних виробів  ${2}


Неможливість опублікувати на закупівлю медичних виробів з невалідним id виробу
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_gmdn_invalid_addclass_id  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword And Expect Error  *  Можливість оголосити тендер з використанням валідації класифікатор медичних виробів  ${3}


Неможливість опублікувати на закупівлю медичних виробів з невалідним description виробу
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_gmdn_invalid_addclass_description  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword And Expect Error  *  Можливість оголосити тендер з використанням валідації класифікатор медичних виробів  ${4}


Неможливість опублікувати тендер cpv не відповідає додатковому класифікатору GMDN
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_gmdn_invalid_addclass  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword And Expect Error  *  Можливість оголосити тендер з використанням валідації класифікатор медичних виробів  ${5}


Неможливість опублікувати тендер на закупівлю медичних виробів з INN
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_gmdn_inn_addclass  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword And Expect Error  *  Можливість оголосити тендер з використанням валідації класифікатор медичних виробів  ${6}


Неможливість опублікувати тендер на закупівлю з невідповідним кодом ЄДРПОУ
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_invalid_edrpou  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword And Expect Error  *  Можливість оголосити тендер з використанням валідації план-тендер  ${1}


Неможливість опублікувати тендер на закупівлю з невідповідною схемою
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_invalid_schema  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword And Expect Error  *  Можливість оголосити тендер з використанням валідації план-тендер  ${2}


Неможливість опублікувати тендер на закупівлю з невідповідним cpv кодом
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_invalid_cpv  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword And Expect Error  *  Можливість оголосити тендер з використанням валідації план-тендер  ${3}


Неможливість опублікувати тендер на закупівлю з невідповідним типом процедури
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender_invalid_procurementMethodType  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword And Expect Error  *  Можливість оголосити тендер з використанням валідації план-тендер  ${4}


Перевірити статус плану - завершено
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних плану
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      plan_status_complete_view
  ...      critical
  Можливість перевірити статус плану після публікації тендера


Можливість знайти тендер по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      find_tender  level1
  ...      critical
  Можливість знайти тендер по ідентифікатору для усіх користувачів

##############################################################################################
#             Відображення основних даних тендера
##############################################################################################

Відображення заголовку тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level1
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title тендера для користувача ${viewer}


Відображення опису тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      non-critical
  Звірити відображення поля description тендера для користувача ${viewer}


Відображення типу оплати
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_milestone  level2
  ...      non-critical
  Звірити відображення поля code усіх умов оплати для усіх користувачів


Відображення події яка ініціює оплату
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_milestone  level2
  ...      non-critical
  Звірити відображення поля title усіх умов оплати для усіх користувачів


Відображення розміру оплати
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_milestone  level2
  ...      non-critical
  Звірити відображення поля percentage усіх умов оплати для усіх користувачів


Відображення к-ті днів періоду оплати
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_milestone  level2
  ...      non-critical
  Звірити відображення поля duration.days усіх умов оплати для усіх користувачів


Відображення типу днів періоду оплати
    [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_milestone  level2
  ...      non-critical
  Звірити відображення поля duration.type усіх умов оплати для усіх користувачів


Відображення виду предмету закупівлі тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      non-critical
  Звірити відображення поля mainProcurementCategory тендера для користувача ${viewer}


Відображення бюджету тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_value  level1
  ...      critical
  Звірити відображення поля value.amount тендера для усіх користувачів


Відображення валюти тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_value  level2
  ...      non-critical
  Звірити відображення поля value.currency тендера для користувача ${viewer}


Відображення ПДВ в бюджеті тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_value  level2
  ...      non-critical
  Звірити відображення поля value.valueAddedTaxIncluded тендера для користувача ${viewer}


Відображення ідентифікатора тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      critical
  Звірити відображення поля tenderID тендера із ${TENDER['TENDER_UAID']} для користувача ${viewer}


Відображення імені замовника тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      critical
  Звірити відображення поля procuringEntity.name тендера для користувача ${viewer}


Відображення початку періоду уточнення тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Run Keyword IF  'open' in '${MODE}'
  ...      Отримати дані із поля enquiryPeriod.startDate тендера для усіх користувачів
  ...      ELSE
  ...      Звірити відображення дати enquiryPeriod.startDate тендера для усіх користувачів


Відображення закінчення періоду уточнення тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      critical
  Run Keyword IF  'open' in '${MODE}'
  ...      Отримати дані із поля enquiryPeriod.endDate тендера для усіх користувачів
  ...      ELSE
  ...      Звірити відображення дати enquiryPeriod.endDate тендера для усіх користувачів


Відображення початку періоду прийому пропозицій тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      non-critical
  Звірити відображення дати tenderPeriod.startDate тендера для усіх користувачів


Відображення закінчення періоду прийому пропозицій тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      critical
  Звірити відображення дати tenderPeriod.endDate тендера для усіх користувачів


Відображення мінімального кроку тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_minimalStep  level2
  ...      critical
  Звірити відображення поля minimalStep.amount тендера для користувача ${viewer}


Відображення типу оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      open_tender_view  level2
  ...      non-critical
  Звірити відображення поля procurementMethodType тендера для усіх користувачів


Відображення закінчення періоду подання скарг на оголошений тендер
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      open_tender_view
  ...      non-critical
  Отримати дані із поля complaintPeriod.endDate тендера для усіх користувачів


Відображення максимальної кількості кваліфікованих учасників
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_framework
  ...      critical
  Звірити відображення поля maxAwardsCount тендера для усіх користувачів


Відображення тривалості угоди
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_framework
  ...      critical
  Звірити відображення поля agreementDuration тендера для усіх користувачів

##############################################################################################
#             Відображення основних даних предмету
##############################################################################################

Відображення опису номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description усіх предметів для усіх користувачів


Відображення дати початку доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_deliveryDate  level2
  ...      non-critical
  Звірити відображення дати deliveryDate.startDate усіх предметів для користувача ${viewer}


Відображення дати кінця доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_deliveryDate  level2
  ...      non-critical
  Звірити відображення дати deliveryDate.endDate усіх предметів для користувача ${viewer}


Відображення координати доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_coordinates
  ...      non-critical
  Звірити відображення координат усіх предметів для користувача ${viewer}


Відображення країни доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      non-critical
  Звірити відображення поля deliveryAddress.countryName усіх предметів для користувача ${viewer}


Відображення пошт. коду доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Звірити відображення поля deliveryAddress.postalCode усіх предметів для користувача ${viewer}


Відображення регіону доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      non-critical
  Звірити відображення поля deliveryAddress.region усіх предметів для користувача ${viewer}


Відображення назви нас. пункту доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Звірити відображення поля deliveryAddress.locality усіх предметів для користувача ${viewer}


Відображення вулиці доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Звірити відображення поля deliveryAddress.streetAddress усіх предметів для користувача ${viewer}


Відображення схеми класифікації номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Звірити відображення поля classification.scheme усіх предметів для користувача ${viewer}
  Run Keyword If  "${USERS.users['${tender_owner}'].initial_data.data['items'][0]['classification']['id']}" == "33600000-6"
  ...      Звірити відображення поля additionalClassifications[0].scheme усіх предметів для користувача ${viewer}


Відображення ідентифікатора класифікації номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Звірити відображення поля classification.id усіх предметів для користувача ${viewer}
  Run Keyword If  "${USERS.users['${tender_owner}'].initial_data.data['items'][0]['classification']['id']}" == "33600000-6"
  ...      Звірити відображення поля additionalClassifications[0].id усіх предметів для користувача ${viewer}


Відображення опису класифікації номенклатур тенедра
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Звірити відображення поля classification.description усіх предметів для користувача ${viewer}
  Run Keyword If  "${USERS.users['${tender_owner}'].initial_data.data['items'][0]['classification']['id']}" == "33600000-6"
  ...      Звірити відображення поля additionalClassifications[0].description усіх предметів для користувача ${viewer}


Відображення назви одиниці номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_unit_name  level2+
  ...      non-critical
  Звірити відображення поля unit.name усіх предметів для користувача ${viewer}


Відображення коду одиниці виміру номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_unit_code
  ...      non-critical
  Звірити відображення поля unit.code усіх предметів для користувача ${viewer}


Відображення кількості номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_quantity  level2
  ...      non-critical
  Звірити відображення поля quantity усіх предметів для користувача ${viewer}


Відображення мінімального кроку підвищення показника ефективності енергосервісного договору тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      esco_tender_view
  ...      critical
  Отримати дані із поля minimalStepPercentage тендера для усіх користувачів


Відображення облікової ставки НБУ
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      esco_tender_view
  ...      critical
  Звірити відображення поля NBUdiscountRate тендера для користувача ${viewer}


Відображення джерела фінансування закупівлі
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      esco_tender_view
  ...      critical
  Звірити відображення поля fundingKind тендера для усіх користувачів


Відображення фіксованого відсотка суми скорочення витрат замовника тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      esco_tender_view
  ...      critical
  Отримати дані із поля yearlyPaymentsPercentageRange тендера для усіх користувачів


##############################################################################################
#             Відображення основних даних МНН/АТХ
##############################################################################################

Відображення схеми МНН
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних МНН/АТХ
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_sheme_inn  level1
  ...      critical
  Звірити відображення поля additionalClassifications[0].scheme усіх предметів для користувача ${viewer}


Відображення ідентифікатора МНН
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних МНН/АТХ
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_id_inn  level1
  ...      critical
  Звірити відображення поля additionalClassifications[0].id усіх предметів для користувача ${viewer}


Відображення опису МНН
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних МНН/АТХ
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_description_inn  level1
  ...      critical
  Звірити відображення поля additionalClassifications[0].description усіх предметів для користувача ${viewer}


Відображення схеми АТХ
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних МНН/АТХ
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_sheme_atc  level1
  ...      critical
  Звірити відображення поля additionalClassifications[1].scheme усіх предметів для користувача ${viewer}


Відображення ідентифікатора АТХ
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних МНН/АТХ
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_id_atc  level1
  ...      critical
  Звірити відображення поля additionalClassifications[1].id усіх предметів для користувача ${viewer}

##############################################################################################
#             Відображення основних даних лоту
##############################################################################################

Відображення заголовку лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      lot_view  level1
  ...      critical
  Звірити відображення поля title усіх лотів для усіх користувачів


Відображення опису лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lot_view  level2
  ...      critical
  Звірити відображення поля description усіх лотів для користувача ${viewer}


Відображення бюджету лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lot_view_value  level2
  ...      critical
  Звірити відображення поля value.amount усіх лотів для усіх користувачів


Відображення валюти лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lot_view_value  level2
  ...      non-critical
  Звірити відображення поля value.currency усіх лотів для користувача ${viewer}


Відображення ПДВ в бюджеті лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lot_view_value  level2
  ...      non-critical
  Звірити відображення поля value.valueAddedTaxIncluded усіх лотів для користувача ${viewer}


Відображення мінімального кроку лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lot_view_minimalStep  level2
  ...      non-critical
  Звірити відображення поля minimalStep.amount усіх лотів для усіх користувачів


Відображення валюти мінімального кроку лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lot_view_minimalStep  level2
  ...      non-critical
  Звірити відображення поля minimalStep.currency усіх лотів для користувача ${viewer}


Відображення ПДВ в мінімальному кроці лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lot_view_minimalStep  level2
  ...      non-critical
  Звірити відображення поля minimalStep.valueAddedTaxIncluded усіх лотів для користувача ${viewer}


Відображення мінімального кроку підвищення показника ефективності енергосервісного договору лота
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      esco_lot_view
  ...      critical
  Звірити відображення поля minimalStepPercentage усіх лотів для користувача ${viewer}


Відображення джерела фінансування лота
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      esco_lot_view
  ...      critical
  Звірити відображення поля fundingKind усіх лотів для користувача ${viewer}


Відображення фіксованого відсотка суми скорочення витрат замовника лота
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      esco_lot_view
  ...      critical
  Звірити відображення поля yearlyPaymentsPercentageRange усіх лотів для користувача ${viewer}


##############################################################################################
#             Відображення основних даних предмету
##############################################################################################

Відображення заголовку нецінових показників
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення нецінових показників
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      meat_view  level2
  ...      critical
  Звірити відображення поля title усіх нецінових показників для усіх користувачів


Відображення опису нецінових показників
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення нецінових показників
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      meat_view  level2
  ...      critical
  Звірити відображення поля description усіх нецінових показників для користувача ${viewer}


Відображення відношення нецінових показників
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення нецінових показників
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      featureOf_meat_view  level2
  ...      non-critical
  Звірити відображення поля featureOf усіх нецінових показників для користувача ${viewer}

##############################################################################################
#             Відображення основних даних донора
##############################################################################################

Відображення назви донора
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення донора тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      funders_view
  ...      critical
  Звірити відображення поля name усіх донорів для усіх користувачів


Відображення назви країни донора
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення донора тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      funders_view
  ...      critical
  Звірити відображення поля address.countryName усіх донорів для усіх користувачів


Відображення назви нас. пункту донора
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення донора тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      funders_view
  ...      critical
  Звірити відображення поля address.locality усіх донорів для усіх користувачів


Відображення поштового коду адреси донора
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення донора тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      funders_view
  ...      critical
  Звірити відображення поля address.postalCode усіх донорів для усіх користувачів


Відображення регіону адреси донора
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення донора тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      funders_view
  ...      critical
  Звірити відображення поля address.region усіх донорів для усіх користувачів


Відображення вулиці адреси донора
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення донора тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      funders_view
  ...      critical
  Звірити відображення поля address.streetAddress усіх донорів для усіх користувачів


Відображення url веб-сторінки контактної особи
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення донора тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      funders_url_view
  ...      non-critical
  Звірити відображення поля contactPoint.url усіх донорів для усіх користувачів


Відображення id донора
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення донора тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      funders_view
  ...      critical
  Звірити відображення поля identifier.id усіх донорів для усіх користувачів


Відображення юридичної назви донора
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення донора тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      funders_view
  ...      critical
  Звірити відображення поля identifier.legalName усіх донорів для усіх користувачів


Відображення схеми донора
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення донора тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      funders_view
  ...      critical
  Звірити відображення поля identifier.scheme усіх донорів для усіх користувачів

##############################################################################################
#             Редагування тендера
##############################################################################################

Можливість змінити дату закінчення періоду подання пропозиції на 1 день
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      extend_tendering_period  level3
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${endDate}=  add_minutes_to_date  ${USERS.users['${tender_owner}'].tender_data.data.tenderPeriod.endDate}  1
  Можливість змінити поле tenderPeriod.endDate тендера на ${endDate}
  Remove From Dictionary  ${USERS.users['${tender_owner}'].tender_data.data.tenderPeriod}  endDate


Відображення зміни закінчення періоду прийому пропозицій тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      extend_tendering_period  level2
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення дати tenderPeriod.endDate тендера для усіх користувачів


Можливість змінити максимальну кількість кваліфікованих учасників
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_maxAwardsCount  level3
  ...      non-critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${maxAwardsCount}=  create_fake_number  6  8
  Можливість змінити поле maxAwardsCount тендера на ${maxAwardsCount}
  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data}  maxAwardsCount
  Set To Dictionary  ${USERS.users['${tender_owner}'].initial_data.data}  new_maxAwardsCount=${maxAwardsCount}


Відображення зміненої максимальної кількості кваліфікованих учасників
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_maxAwardsCount
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля maxAwardsCount тендера із ${USERS.users['${tender_owner}'].initial_data.data.new_maxAwardsCount} для користувача ${viewer}


Можливість додати документацію до тендера
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_doc  level3
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати документацію до тендера


Можливість додати документацію до всіх лотів
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_lot_doc  level3
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати документацію до всіх лотів


Відображення заголовку документації до тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_tender_doc  level2
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title документа ${USERS.users['${tender_owner}']['tender_document']['doc_id']} із ${USERS.users['${tender_owner}'].tender_document.doc_name} для користувача ${viewer}


Можливість отримати інформацію про документацію до тендера
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      get_file_properties
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  Отримати інформацію про документ тендера ${USERS.users['${tender_owner}'].tender_document.doc_id} ${tender_owner}


Можливість отримати інформацію про документацію до лотів
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      get_file_properties
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  Отримати інформацію про документ лотів ${USERS.users['${tender_owner}'].lots_documents[0].doc_id} ${tender_owner}


Можливість перевірити інформацію про документацію до тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      compare_file_properties
  Завантажити дані про тендер
  Звірити інформацію про документацію ${USERS.users['${viewer}'].tender_file_properties} ${viewer}


Можливість перевірити інформацію про документацію до лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      compare_file_properties
  Завантажити дані про тендер
  Звірити інформацію про документацію ${USERS.users['${viewer}'].lot_file_properties} ${viewer}


Відображення заголовку документації до всіх лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_lot_doc  level2
  ...      critical
  Звірити відображення заголовку документації до всіх лотів для користувача ${viewer}


Відображення вмісту документації до тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_tender_doc  level2
  ...      non-critical
  Звірити відображення вмісту документа ${USERS.users['${tender_owner}'].tender_document.doc_id} із ${USERS.users['${tender_owner}'].tender_document.doc_content} для користувача ${viewer}


Відображення вмісту документації до всіх лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_lot_doc  level2
  ...      critical
  Звірити відображення вмісту документації до всіх лотів для користувача ${viewer}


Можливість зменшити бюджет лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_lot_value_amount  level2
  ...      non-critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити на 99 відсотки бюджет 0 лоту


Можливість збільшити бюджет лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_lot_value_amount  level3
  ...      non-critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити на 101 відсотки бюджет 0 лоту


Можливість створення лоту із прив’язаним предметом закупівлі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_lot  level3
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створення лоту із прив’язаним предметом закупівлі


Відображення опису номенклатури у новому лоті
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_lot  level2
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description у новоствореному предметі для усіх користувачів


Відображення заголовку нового лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      add_lot  level2
  ...      non-critical
  Звірити відображення поля title у новоствореному лоті для усіх користувачів


Можливість додати предмет закупівлі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_item  level3
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword IF  ${NUMBER_OF_LOTS} == 0
  ...      Можливість додати предмет закупівлі в тендер
  ...      ELSE
  ...      Можливість додати предмет закупівлі в -1 лот


Відображення опису нової номенклатури
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_item  level2
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description у новоствореному предметі для усіх користувачів


Можливість видалити предмет закупівлі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_item  level3
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword IF  ${NUMBER_OF_LOTS} == 0
  ...      Можливість видалити предмет закупівлі з тендера
  ...      ELSE
  ...      Можливість видалити предмет закупівлі з -1 лоту


Можливість видалення лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_lot
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість видалення -1 лоту


Можливість додати неціновий показник на тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_meat  level3
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати неціновий показник на тендер


Відображення заголовку нецінового показника на тендер
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення нецінових показників
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      add_tender_meat  level2
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title у новоствореному неціновому показнику для усіх користувачів


Відображення опису нецінового показника на тендер
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення нецінових показників
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_tender_meat
  ...      non-critical
  Звірити відображення поля description у новоствореному неціновому показнику для користувача ${viewer}


Відображення відношення нецінового показника на тендер
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення нецінових показників
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      featureOf_meat_view
  ...      non-critical
  Звірити відображення поля featureOf у новоствореному неціновому показнику для користувача ${viewer}


Можливість видалити неціновий показник на тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_tender_meat  level3
  ...      critical
  Можливість видалити -1 неціновий показник


Можливість додати неціновий показник на перший лот
  [Tags]   ${USERS.users['${tender_owner}'].broker}:  Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_lot_meat  level3
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати неціновий показник на 0 лот


Відображення заголовку нецінового показника на лот
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення нецінових показників
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      add_lot_meat  level2
  ...      non-critical
  Звірити відображення поля title у новоствореному неціновому показнику для усіх користувачів


Відображення опису нецінового показника на лот
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення нецінових показників
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_lot_meat
  ...      non-critical
  Звірити відображення поля description у новоствореному неціновому показнику для користувача ${viewer}


Відображення відношення нецінового показника на лот
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення нецінових показників
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_lot_meat
  ...      non-critical
  Звірити відображення поля featureOf у новоствореному неціновому показнику для користувача ${viewer}


Можливість видалити неціновий показник на лот
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_lot_meat  level3
  ...      critical
  Можливість видалити -1 неціновий показник


Можливість додати неціновий показник на перший предмет
  [Tags]   ${USERS.users['${tender_owner}'].broker}:  Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_item_meat  level3
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати неціновий показник на 0 предмет


Відображення заголовку нецінового показника на предмет
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення нецінових показників
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      add_item_meat  level2
  ...      non-critical
  Звірити відображення поля title у новоствореному неціновому показнику для усіх користувачів


Відображення опису нецінового показника на предмет
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення нецінових показників
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_item_meat
  ...      non-critical
  Звірити відображення поля description у новоствореному неціновому показнику для користувача ${viewer}


Відображення відношення нецінового показника на предмет
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення нецінових показників
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_item_meat
  ...      non-critical
  Звірити відображення поля featureOf у новоствореному неціновому показнику для користувача ${viewer}


Можливість видалити неціновий показник на предмет
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_item_meat  level3
  ...      critical
  Можливість видалити -1 неціновий показник


Можливість видалити донора
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_funder
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість видалити донора 0


Можливість додати донора
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_funder
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати донора


Неможливість видалити ім'я донора
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_funder_field
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword And Expect Error  *  Можливість видалити поле name з донора 0


Неможливість видалити ім'я контактної особи донора
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_funder_field
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword And Expect Error  *  Можливість видалити поле contactPoint.name з донора 0


Неможливість видалити назву країни з адреси донора
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_funder_field
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword And Expect Error  *  Можливість видалити поле address.countryName з донора 0


Неможливість змінити id ідентифікатора донора
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість редагувати тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      change_funder_during_enquiry_period
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_id}=  create_fake_number  10000  99999
  Перевірити неможливість зміни поля funders[0].identifier.id тендера на значення ${new_id} для користувача ${tender_owner}


Неможливість змінити схему ідентифікатора донора
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість редагувати тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      change_funder_during_enquiry_period
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_scheme}=  get_fake_funder_scheme
  Перевірити неможливість зміни поля funders[0].identifier.scheme тендера на значення ${new_scheme} для користувача ${tender_owner}

##############################################################################################
#             QUESTIONS
##############################################################################################

Можливість задати запитання на тендер
  [Tags]   ${USERS.users['${provider}'].broker}: Задання запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      ask_question_to_tender
  ...      critical
  [Setup]  Дочекатись дати початку періоду уточнень  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість задати запитання на тендер користувачем ${provider}


Відображення заголовку анонімного запитання на тендер без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      ask_question_to_tender
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title запитання на тендер для усіх користувачів


Відображення опису анонімного запитання на тендер без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      ask_question_to_tender
  ...      non-critical
  Звірити відображення поля description запитання на тендер для користувача ${viewer}


Можливість відповісти на запитання на тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відповідь на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      answer_question_to_tender
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти на запитання на тендер


Відображення відповіді на запитання на тендер
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення відповіді на запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      answer_question_to_tender
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля answer запитання на тендер для користувача ${viewer}


Можливість задати запитання на всі предмети
  [Tags]   ${USERS.users['${provider}'].broker}: Задання запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      ask_question_to_item
  ...      critical
  [Setup]  Дочекатись дати початку періоду уточнень  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Можливість задати запитання на ${item_index} предмет користувачем ${provider}


Відображення заголовку анонімного запитання на всі предмети без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer tender_owner provider provider1
  ...      ${USERS.users['${viewer}'].broker}
  ...      ask_question_to_item
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Звірити відображення поля title запитання на ${item_index} предмет для усіх користувачів


Відображення опису анонімного запитання на всі предмети без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      ask_question_to_item
  ...      critical
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Звірити відображення поля description запитання на ${item_index} предмет для користувача ${viewer}


Можливість відповісти на запитання на всі предмети
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відповідь на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      answer_question_to_item
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Можливість відповісти на запитання на ${item_index} предмет


Відображення відповіді на запитання на всі предмети
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення відповіді на запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      answer_question_to_item
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Звірити відображення поля answer запитання на ${item_index} предмет для користувача ${viewer}


Можливість задати запитання на всі лоти
  [Tags]   ${USERS.users['${provider}'].broker}: Задання запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      ask_question_to_lot
  ...      critical
  [Setup]  Дочекатись дати початку періоду уточнень  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  :FOR  ${lot_index}  IN RANGE  ${NUMBER_OF_LOTS}
  \  Можливість задати запитання на ${lot_index} лот користувачем ${provider}


Відображення заголовку анонімного запитання на всі лоти без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer tender_owner provider provider1
  ...      ${USERS.users['${viewer}'].broker}
  ...      ask_question_to_lot
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  :FOR  ${lot_index}  IN RANGE  ${NUMBER_OF_LOTS}
  \  Звірити відображення поля title запитання на ${lot_index} лот для усіх користувачів


Відображення опису анонімного запитання на всі лоти без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      ask_question_to_lot
  ...      non-critical
  :FOR  ${lot_index}  IN RANGE  ${NUMBER_OF_LOTS}
  \  Звірити відображення поля description запитання на ${lot_index} лот для користувача ${viewer}


Можливість відповісти на запитання на всі лоти
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відповідь на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      answer_question_to_lot
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  :FOR  ${lot_index}  IN RANGE  ${NUMBER_OF_LOTS}
  \  Можливість відповісти на запитання на ${lot_index} лот


Відображення відповіді на запитання на всі лоти
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення відповіді на запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      answer_question_to_lot
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  :FOR  ${lot_index}  IN RANGE  ${NUMBER_OF_LOTS}
  \  Звірити відображення поля answer запитання на ${lot_index} лот для користувача ${viewer}


Можливість внести зміни у тендер після запитання
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_tender_after_questions
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_description}=  create_fake_sentence
  Можливість змінити поле description тендера на ${new_description}
  Remove From Dictionary  ${USERS.users['${tender_owner}'].tender_data.data}  description


Можливість внести зміни у лот після запитання
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_lot_after_questions
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_description}=  create_fake_sentence
  Можливість змінити поле description 0 лоту на ${new_description}
  Remove From Dictionary  ${USERS.users['${tender_owner}'].tender_data.data.lots[0]}  description


Неможливість змінити дані про донора після завершення періоду уточнень
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      change_funder_after_enquiry_period
  ...      critical
  [Setup]  Дочекатись дати закінчення періоду уточнень  ${tender_owner}  ${TENDER['TENDER_UAID']}
  ${new_legalName}=  create_fake_title
  Перевірити неможливість зміни поля funders[0].identifier.legalName тендера на значення ${new_legalName} для користувача ${tender_owner}
  Remove From Dictionary  ${USERS.users['${tender_owner}'].tender_data.data.funders[0].identifier}  legalName

##############################################################################################
#             TENDER COMPLAINTS
##############################################################################################

Можливість створити вимогу про виправлення умов закупівлі, додати до неї документацію і подати її користувачем
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  create_tender_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення умов закупівлі із документацією


Відображення опису вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_tender_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description вимоги із ${USERS.users['${provider}'].tender_claim_data.claim.data.description} для користувача ${viewer}


Відображення ідентифікатора вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_tender_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля complaintID вимоги із ${USERS.users['${provider}'].tender_claim_data.complaintID} для користувача ${viewer}


Відображення заголовку вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_tender_claim
  Звірити відображення поля title вимоги із ${USERS.users['${provider}'].tender_claim_data.claim.data.title} для користувача ${viewer}


Відображення заголовку документа до вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_tender_claim
  Звірити відображення поля title документа ${USERS.users['${provider}'].tender_claim_data.doc_id} до скарги ${USERS.users['${provider}'].tender_claim_data.complaintID} з ${USERS.users['${provider}'].tender_claim_data.doc_name} для користувача ${viewer}


Відображення вмісту документа до вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_tender_claim
  Звірити відображення вмісту документа ${USERS['${provider}'].tender_claim_data.doc_id} до скарги ${USERS.users['${provider}'].tender_claim_data.complaintID} з ${USERS['${provider}'].tender_claim_data.doc_content} для користувача ${viewer}


Відображення поданого статусу вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_tender_claim
  Звірити відображення поля status вимоги із claim для користувача ${viewer}


Можливість відповісти на вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес оскарження
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  answer_tender_claim
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти resolved на вимогу про виправлення умов tender


Відображення статусу 'answered' вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  answer_tender_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із answered для користувача ${viewer}


Відображення типу вирішення вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  answer_tender_claim
  Звірити відображення поля resolutionType вимоги із ${USERS.users['${tender_owner}'].tender_claim_data.claim_answer.data.resolutionType} для користувача ${viewer}


Відображення вирішення вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  answer_tender_claim
  Звірити відображення поля resolution вимоги із ${USERS.users['${tender_owner}'].tender_claim_data.claim_answer.data.resolution} для користувача ${viewer}


Можливість підтвердити задоволення вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  resolve_tender_claim
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити задоволення вимоги про виправлення умов закупівлі


Відображення статусу 'resolved' вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  resolve_tender_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із resolved для користувача ${viewer}


Відображення задоволення вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  resolve_tender_claim
  Звірити відображення поля satisfied вимоги із ${USERS.users['${provider}'].tender_claim_data.claim_answer_confirm.data.satisfied} для користувача ${viewer}


Можливість перетворити вимогу про виправлення умов закупівлі в скаргу
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  escalate_tender_claim
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість перетворити вимогу про виправлення умов закупівлі в скаргу


Відображення статусу 'pending' після 'claim -> answered' вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  escalate_tender_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із pending для користувача ${viewer}


Відображення незадоволення вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  escalate_tender_claim
  Звірити відображення поля satisfied вимоги із ${USERS.users['${provider}'].tender_claim_data.escalation.data.satisfied} для користувача ${viewer}


Можливість скасувати вимогу/скаргу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  cancel_tender_claim
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати вимогу про виправлення умов закупівлі


Відображення статусу 'cancelled' вимоги/скарги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  cancel_tender_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із cancelled для користувача ${viewer}


Відображення причини скасування вимоги/скарги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  cancel_tender_claim
  Звірити відображення поля cancellationReason вимоги із ${USERS.users['${provider}'].tender_claim_data.cancellation.data.cancellationReason} для користувача ${viewer}


Можливість внести зміни у тендер після оскарження умов закупівлі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_tender_after_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_description}=  create_fake_sentence
  Можливість змінити поле description тендера на ${new_description}
  Remove From Dictionary  ${USERS.users['${tender_owner}'].tender_data.data}  description

##############################################################################################
#             LOT COMPLAINTS
##############################################################################################

Можливість створити і подати вимогу про виправлення умов лоту
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  create_lot_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення умов 0 лоту із документацією


Відображення опису вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_lot_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description вимоги про виправлення умов 0 лоту із ${USERS.users['${provider}'].lot_claim_data.claim.data.description} для користувача ${viewer}


Відображення ідентифікатора вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_tender_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля complaintID вимоги про виправлення умов 0 лоту із ${USERS.users['${provider}'].lot_claim_data.complaintID} для користувача ${viewer}


Відображення заголовку вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_lot_claim
  Звірити відображення поля title вимоги про виправлення умов 0 лоту із ${USERS.users['${provider}'].lot_claim_data.claim.data.title} для користувача ${viewer}


Відображення заголовку документа до вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_lot_claim
  Звірити відображення поля title документа ${USERS.users['${provider}'].lot_claim_data.doc_id} до скарги ${USERS.users['${provider}'].lot_claim_data.complaintID} з ${USERS.users['${provider}'].lot_claim_data.doc_name} для користувача ${viewer}


Відображення вмісту документа до вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_lot_claim
  Звірити відображення вмісту документа ${USERS['${provider}'].lot_claim_data.doc_id} до скарги ${USERS.users['${provider}'].lot_claim_data.complaintID} з ${USERS['${provider}'].lot_claim_data.doc_content} для користувача ${viewer}


Відображення поданого статусу вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_lot_claim
  Звірити відображення поля status вимоги про виправлення умов 0 лоту із claim для користувача ${viewer}


Можливість відповісти на вимогу про виправлення умов лоту
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес оскарження
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  answer_lot_claim
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти resolved на вимогу про виправлення умов lot


Відображення статусу 'answered' вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  answer_lot_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення умов 0 лоту із answered для користувача ${viewer}


Відображення типу вирішення вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  answer_lot_claim
  Звірити відображення поля resolutionType вимоги про виправлення умов 0 лоту із ${USERS.users['${tender_owner}'].lot_claim_data.claim_answer.data.resolutionType} для користувача ${viewer}


Відображення вирішення вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  answer_lot_claim
  Звірити відображення поля resolution вимоги про виправлення умов 0 лоту із ${USERS.users['${tender_owner}'].lot_claim_data.claim_answer.data.resolution} для користувача ${viewer}


Можливість підтвердити задоволення вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  resolve_lot_claim
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити задоволення вимоги про виправлення умов лоту


Відображення статусу 'resolved' вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  resolve_lot_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення умов 0 лоту із resolved для користувача ${viewer}


Відображення задоволення вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  resolve_lot_claim
  Звірити відображення поля satisfied вимоги про виправлення умов 0 лоту із ${USERS.users['${provider}'].lot_claim_data.claim_answer_confirm.data.satisfied} для користувача ${viewer}


Можливість перетворити вимогу про виправлення умов лоту в скаргу
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  escalate_lot_claim
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість перетворити вимогу про виправлення умов лоту в скаргу


Відображення статусу 'pending' після 'claim -> answered' вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  escalate_lot_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення умов 0 лоту із pending для користувача ${viewer}


Відображення незадоволення вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  escalate_lot_claim
  Звірити відображення поля satisfied вимоги про виправлення умов 0 лоту із ${USERS.users['${provider}'].lot_claim_data.escalation.data.satisfied} для користувача ${viewer}


Можливість скасувати вимогу/скаргу про виправлення умов лоту
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  cancel_lot_claim
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати вимогу про виправлення умов лоту


Відображення статусу 'cancelled' вимоги/скарги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  cancel_lot_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення умов 0 лоту із cancelled для користувача ${viewer}


Відображення причини скасування вимоги/скарги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  cancel_lot_claim
  Звірити відображення поля cancellationReason вимоги про виправлення умов 0 лоту із ${USERS.users['${provider}'].lot_claim_data.cancellation.data.cancellationReason} для користувача ${viewer}


Можливість внести зміни у лот після оскарження умов лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_lot_after_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_description}=  create_fake_sentence
  Можливість змінити поле description 0 лоту на ${new_description}
  Remove From Dictionary  ${USERS.users['${tender_owner}'].tender_data.data.lots[0]}  description

##############################################################################################
#             BIDDING
##############################################################################################

Неможливість подати пропозицію до початку періоду подачі пропозицій першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_before_tendering_period
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Run Keyword And Expect Error  *  Можливість подати цінову пропозицію користувачем ${provider}


Неможливість подати цінову пропозицію без прив’язки до лоту
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_without_related_lot
  ...      non-critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  Неможливість подати цінову пропозицію без прив’язки до лоту користувачем ${provider}


Неможливість подати цінову пропозицію без нецінових показників
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_without_parameters
  ...      non-critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  Неможливість подати цінову пропозицію без нецінових показників користувачем ${provider}


Можливість подати пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_by_provider  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider}


Можливість подати пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_with_criteria_by_provider  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію в статусі draft користувачем ${provider}
  Можливість завантажити документ в пропозицію користувачем ${provider}
  Можливість додати до пропозиції відповідь на критерії користувачем ${provider}
  Можливість активувати пропозицію користувачем ${provider}


Можливість подати пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_with_criteria_by_provider1  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider1}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію в статусі draft користувачем ${provider1}
  Можливість завантажити документ в пропозицію користувачем ${provider1}
  Можливість додати до пропозиції відповідь на критерії користувачем ${provider1}
  Можливість активувати пропозицію користувачем ${provider1}


Можливість подати пропозицію третім учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider2
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_with_criteria_by_provider2  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider2}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію в статусі draft користувачем ${provider2}
  Можливість завантажити документ в пропозицію користувачем ${provider2}
  Можливість додати до пропозиції відповідь на критерії користувачем ${provider2}
  Можливість активувати пропозицію користувачем ${provider2}


Можливість подати пропозицію з фіксованою сумою першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_fixed_amount_by_provider  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію на суму ${BID_AMOUNT_1} користувачем ${provider}


Можливість подати пропозицію з фіксованою сумою першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_fixed_amount_with_criteria_by_provider  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію в статусі draft на суму ${BID_AMOUNT_1} користувачем ${provider}
  Можливість завантажити документ в пропозицію користувачем ${provider}
  Можливість додати до пропозиції відповідь на критерії користувачем ${provider}
  Можливість активувати пропозицію користувачем ${provider}


Можливість подати пропозицію першим учасником на першому етапі
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_with_criteria_by_provider_first_stage  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію в статусі draft на першому етапі користувачем ${provider}
  Можливість завантажити документ в пропозицію користувачем ${provider}
  Можливість додати до пропозиції відповідь на критерії користувачем ${provider}
  Можливість активувати пропозицію користувачем ${provider}


Можливість зменшити пропозицію на 5% першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      modify_bid_by_provider
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість зменшити пропозицію до 95 відсотків користувачем ${provider}


Можливість завантажити документ в пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_doc_to_bid_by_provider
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ в пропозицію користувачем ${provider}


Можливість змінити документацію цінової пропозиції першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_doc_to_bid_by_provider
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити документацію цінової пропозиції користувачем ${provider}


Можливість подати пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_provider1  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider1}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider1}


Можливість подати пропозицію з фіксованою сумою другим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_fixed_amount_by_provider1  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію на суму ${BID_AMOUNT_2} користувачем ${provider1}


Можливість подати пропозицію з фіксованою сумою другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_fixed_amount_with_criteria_by_provider1  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider1}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію в статусі draft на суму ${BID_AMOUNT_2} користувачем ${provider1}
  Можливість завантажити документ в пропозицію користувачем ${provider1}
  Можливість додати до пропозиції відповідь на критерії користувачем ${provider1}
  Можливість активувати пропозицію користувачем ${provider1}


Можливість зменшити пропозицію на 5% другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      modify_bid_by_provider1
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість зменшити пропозицію до 95 відсотків користувачем ${provider1}


Можливість подати пропозицію третім учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider2
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_provider2  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider2}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider2}


Можливість подати пропозицію з фіксованою сумою третім учасником
  [Tags]   ${USERS.users['${provider2}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider2}'].broker}
  ...      make_bid_fixed_amount_with_criteria_by_provider2  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider2}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію в статусі draft на суму ${BID_AMOUNT_3} користувачем ${provider2}
  Можливість завантажити документ в пропозицію користувачем ${provider2}
  Можливість додати до пропозиції відповідь на критерії користувачем ${provider2}
  Можливість активувати пропозицію користувачем ${provider2}


Можливість подати пропозицію з фіксованою сумою третім учасником
  [Tags]   ${USERS.users['${provider2}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider2}'].broker}
  ...      make_bid_fixed_amount_by_provider2  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider2}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію на суму ${BID_AMOUNT_3} користувачем ${provider2}


Можливість подати пропозицію другим учасником на першому етапі
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_with_criteria_by_provider1_first_stage  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider1}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію в статусі draft на першому етапі користувачем ${provider1}
  Можливість завантажити документ в пропозицію користувачем ${provider1}
  Можливість додати до пропозиції відповідь на критерії користувачем ${provider1}
  Можливість активувати пропозицію користувачем ${provider1}


Можливість подати пропозицію третім учасником на першому етапі
  [Tags]   ${USERS.users['${provider2}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider2}'].broker}
  ...      make_bid_with_criteria_by_provider2_first_stage  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider2}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію в статусі draft на першому етапі користувачем ${provider2}
  Можливість завантажити документ в пропозицію користувачем ${provider2}
  Можливість додати до пропозиції відповідь на критерії користувачем ${provider2}
  Можливість активувати пропозицію користувачем ${provider2}


##############################################################################################
#             ABOVETRHESHOLD  BIDDING
##############################################################################################

Можливість змінити документацію цінової пропозиції з публічної на приватну
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      openeu_make_bid_doc_private_by_provider
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити документацію цінової пропозиції з публічної на приватну учасником ${provider}


Можливість завантажити фінансовий документ до пропозиції першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      openeu_add_financial_bid_doc_by_provider
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до пропозиції учасником  ${provider}  financial_documents


Можливість завантажити фінансовий документ winningBid до пропозиції першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_winningBid_doc_by_provider
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до пропозиції учасником  ${provider}  financial_documents  winningBid


Можливість завантажити кваліфікаційний документ до пропозиції першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      openeu_add_qualification_bid_doc_by_provider
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до пропозиції учасником  ${provider}  qualification_documents


Можливість завантажити документ для критеріїв прийнятності до пропозиції першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      openeu_add_eligibility_bid_doc_by_provider
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до пропозиції учасником  ${provider}  eligibility_documents


Неможливість задати запитання на тендер після завершення періоду уточнень
  [Tags]  ${USERS.users['${provider}'].broker}: Задання запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      ask_question_after_enquiry_period
  ...      non-critical
  [Setup]  Дочекатись дати закінчення періоду уточнень  ${provider}  ${TENDER['TENDER_UAID']}
  Run Keyword And Expect Error  *  Можливість задати запитання на тендер користувачем ${provider}


Неможливість подати вимогу про виправлення умов закупівлі після закінчення періоду подання скарг
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      create_tender_complaint_after_complaint_period
  ...      non-critical
  [Setup]  Дочекатись дати закінчення періоду подання скарг  ${provider}
  Run Keyword And Expect Error  *  Можливість створити вимогу про виправлення умов закупівлі із документацією


Неможливість відповісти на запитання до тендера після завершення періоду відповідей
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Відповідь на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      answer_question_after_clarifications_period
  ...      non-critical
  [Setup]  Дочекатись дати закінчення періоду відповідей на запитання  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Run Keyword And Expect Error  *  Можливість відповісти resolved на вимогу про виправлення умов tender


Неможливість редагувати однопредметний тендер менше ніж за 2 дні до завершення періоду подання пропозицій
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість редагувати тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_tender_in_tendering_period
  ...      non-critical
  ${new_description}=  create_fake_sentence
  Run Keyword And Expect Error  *  Можливість змінити поле description тендера на ${new_description}


Можливість відповісти на запитання до тендера після продовження періоду прийому пропозицій
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Відповідь на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      answer_question_after_clarifications_period
  ...      extend_enquiry_period
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість продовжити період подання пропозиції на 5 днів
  Можливість відповісти на запитання на тендер


Можливість редагувати тендер після продовження періоду прийому пропозицій
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість редагувати тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_tender_in_tendering_period
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_description}=  create_fake_sentence
  Можливість змінити поле description тендера на ${new_description}
  Remove From Dictionary  ${USERS.users['${tender_owner}'].tender_data.data}  description


Можливість редагувати однопредметний тендер більше ніж за 7 днів до завершення періоду подання пропозицій
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      open_modify_tender_in_tendering_period
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_description}=  create_fake_sentence
  Можливість змінити поле description тендера на ${new_description}
  Remove From Dictionary  ${USERS.users['${tender_owner}'].tender_data.data}  description


Відображення зміни статусу першої пропозиції після редагування інформації про тендер
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      open_confirm_first_bid
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Відображення зміни статусу пропозицій на invalid для учасника ${provider}


Відображення зміни статусу другої пропозиції після редагування інформації про тендер
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      open_confirm_second_bid
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider1}
  Відображення зміни статусу пропозицій на invalid для учасника ${provider1}


Можливість підтвердити цінову пропозицію після зміни умов тендера першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      open_confirm_first_bid
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити цінову пропозицію учасником ${provider}


Можливість підтвердити цінову пропозицію після зміни умов тендера другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      open_confirm_second_bid
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити цінову пропозицію учасником ${provider1}


Можливість підтвердити цінову пропозицію після зміни умов третьому учаснику
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider2
  ...      ${USERS.users['${provider1}'].broker}
  ...      open_confirm_third_bid
  ...      non-critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити цінову пропозицію учасником ${provider2}

##############################################################################################

Можливість скасувати пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      cancel_bid_by_provider
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати цінову пропозицію користувачем ${provider}


Неможливість побачити цінові пропозиції учасників під час прийому пропозицій
  [Tags]   ${USERS.users['${viewer}'].broker}: Подання пропозиції
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      bid_view_in_tendering_period
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Require Failure  ${viewer}  Отримати інформацію із тендера  ${TENDER['TENDER_UAID']}  bids

##############################################################################################
#             AFTER BIDDING
##############################################################################################

Неможливість завантажити документ першим учасником після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_bid_doc_after_tendering_period_by_provider
  ...      non-critical
  [Setup]  Дочекатись дати закінчення прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  Run Keyword And Expect Error  *  Можливість завантажити документ в пропозицію користувачем ${provider}


Неможливість змінити існуючу документацію пропозиції першим учасником після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider1}'].broker}
  ...      modify_bid_doc_after_tendering_period_by_provider
  ...      non-critical
  Run Keyword And Expect Error  *  Можливість змінити документацію цінової пропозиції користувачем ${provider}


Неможливість задати запитання на тендер після закінчення періоду прийому пропозицій
  [Tags]   ${USERS.users['${provider}'].broker}: Задання запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      ask_question_to_tender_after_tendering_period
  ...      non-critical
  [Setup]  Дочекатись дати закінчення прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  Run Keyword And Expect Error  *  Можливість задати запитання на тендер користувачем ${provider}


Неможливість задати запитання на перший предмет після закінчення періоду прийому пропозицій
  [Tags]   ${USERS.users['${provider}'].broker}: Задання запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      ask_question_to_item_after_tendering_period
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Run Keyword And Expect Error  *  Можливість задати запитання на 0 предмет користувачем ${provider}


Неможливість задати запитання на перший лот після закінчення періоду прийому пропозицій
  [Tags]   ${USERS.users['${provider}'].broker}: Задання запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      ask_question_to_lot_after_tendering_period
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Run Keyword And Expect Error  *  Можливість задати запитання на 0 лот користувачем ${provider}


Неможливість зменшити цінову пропозицію на 5% другим учасником після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      modify_bid_after_tendering_period_by_provider1
  ...      non-critical
  [Setup]  Дочекатись дати закінчення прийому пропозицій  ${provider1}  ${TENDER['TENDER_UAID']}
  Run Keyword And Expect Error  *  Можливість зменшити пропозицію до 95 відсотків користувачем ${provider1}


Неможливість скасувати пропозицію другим учасником після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      cancel_bid_after_tendering_period_by_provider1
  ...      non-critical
  Run Keyword And Expect Error  *  Можливість скасувати цінову пропозицію користувачем ${provider1}


##############################################################################################
#             PRE-QUALIFICATION
##############################################################################################

Неможливість додати документацію до тендера під час кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації пре-кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_add_doc_to_tender
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword And Expect Error  *  Можливість додати документацію до тендера


Неможливість додати документацію до лоту під час кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації пре-кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_add_doc_to_lot
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword And Expect Error  *  Можливість додати документацію до 0 лоту


Дочекатись початку періоду пре-кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Очікування початку періоду пре-кваліфікації Учасників
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      wait_active_pre-qualification_start
  Дочекатись дати початку періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}


Повідомити учасника про невідповідність в тендерній пропозиції
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Усунути невідповідність протягом 24 годин (повідомлення)
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_24h_milestone_pre-qualification
  Повідомлення в qualifications про невіповідність пропозиції 0


Можливість завантажити документ в пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Усунути невідповідність протягом 24 годин (завантажити документ)
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_doc_to_bid_by_provider_24h_pre-qualification
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ для усунення невідповідності в пропозиції в qualifications 0 користувачем ${provider}


Можливість змінити документацію цінової пропозиції першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Усунути невідповідність протягом 24 годин (змінити документ)
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_doc_to_bid_by_provider_24h_pre-qualification
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити документацію цінової пропозиції при усуненні невідповідності користувачем ${provider}


Відображення статусу першої пропозиції кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення пре-кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_view
  ...      non-critical
  [Setup]  Дочекатись дати початку періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Звірити відображення поля qualifications[0].status тендера із pending для користувача ${tender_owner}


Відображення статусу другої пропозиції кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення пре-кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_view
  ...      non-critical
  [Setup]  Дочекатись дати початку періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Звірити відображення поля qualifications[1].status тендера із pending для користувача ${tender_owner}


Можливість дочекатися перевірки учасників по ЄДРПОУ
  [Tags]   ${USERS.users['${viewer}'].broker}: Перевірка користувачів по ЄДРПОУ
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualifications_check_by_edrpou
  [Setup]  Дочекатись дати початку періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Дочекатися перевірки прекваліфікацій  ${tender_owner}  ${TENDER['TENDER_UAID']}


Можливість завантажити документ у кваліфікацію пропозиції першого учасника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Завантажити документ в пре-кваліфікацію
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_add_doc_to_first_bid
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ у кваліфікацію 0 пропозиції


Можливість відповісти на критерії Замовника у кваліфікацію пропозиції першого учасника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відповідь на критерії Замовника в пре-кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_add_criteria_response_first_bid
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Відповісти на критерії Замовника 0 пропозиції


Можливість підтвердити першу пропозицію кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес пре-кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_first_bid  level1
  ...      critical
  [Setup]  Дочекатись дати початку періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити 0 пропозицію кваліфікації


Можливість завантажити документ у кваліфікацію пропозиції другого учасника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес пре-кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_add_doc_to_second_bid
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ у кваліфікацію 1 пропозиції


Можливість відповісти на критерії Замовника у кваліфікацію пропозиції другого учасника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес пре-кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_add_criteria_response_second_bid
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Відповісти на критерії Замовника 1 пропозиції


Можливість відхилити другу пропозицію кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес пре-кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_reject_second_bid
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відхилити 1 пропозиції кваліфікації


Можливість скасувати рішення кваліфікації для другої пропопозиції
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес пре-кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_cancel_second_bid_qualification
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати рішення кваліфікації для 1 пропопозиції


Можливість підтвердити другу пропозицію кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес пре-кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_second_bid  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити 1 пропозицію кваліфікації


Можливість підтвердити другу пропозицію кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес пре-кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_second_bid_after_cancel  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити 2 пропозицію кваліфікації


Можливість підтвердити другу пропозицію кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес пре-кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_second_bid_framawork  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити 2 пропозицію кваліфікації


#Можливість підтвердити третю пропозицію кваліфікації
  #[Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  #...      tender_owner
  #...      ${USERS.users['${tender_owner}'].broker}
  #...      pre-qualification_approve_third_bid  level1
  #...      critical
  #[Teardown]  Оновити LAST_MODIFICATION_DATE
  #Можливість підтвердити -2 пропозицію кваліфікації


Можливість підтвердити третю пропозицію кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес пре-кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_third_bid  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити 2 пропозицію кваліфікації


Можливість підтвердити третю пропозицію кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес пре-кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_third_bid_framework  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити 3 пропозицію кваліфікації


Можливість затвердити остаточне рішення кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес пре-кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_qualifications  level1
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість затвердити остаточне рішення кваліфікації


Відображення статусу блокування перед початком аукціону
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення пре-кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_view
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  Звірити статус тендера  ${tender_owner}  ${TENDER['TENDER_UAID']}  active.pre-qualification.stand-still


Відображення дати закінчення періоду блокування перед початком аукціону
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення пре-кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_view
  ...      non-critical
  [Teardown]  Дочекатись дати закінчення періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Отримати дані із поля qualificationPeriod.endDate тендера для усіх користувачів


Можливість дочекатися початку періоду очікування
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес очікування оскаржень на пре-кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      stage2_pending_status_view
  ...      critical
  Отримати дані із поля qualificationPeriod.endDate тендера для усіх користувачів
  Дочекатись дати закінчення періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Звірити статус тендера  ${tender_owner}  ${TENDER['TENDER_UAID']}  active.stage2.pending


Можливість перевести тендер в статус очікування обробки мостом
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес переведення статусу у active.stage2.waiting.
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      stage2_pending_status_view
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість перевести тендер на статус очікування обробки мостом


Можливість дочекатися завершення роботи мосту
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес очікування обробки мостом
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      wait_bridge_for_work
  ...      critical
  Дочекатися створення нового етапу мостом  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Звірити статус тендера  ${tender_owner}  ${TENDER['TENDER_UAID']}  complete


Можливість активувати тендер другого етапу
  [Tags]   ${USERS.users['${viewer}'].broker}: Активувати тендер другого етапу
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      activate_second_stage
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  Активувати тендер другого етапу


Можливість знайти тендер другого етапу по ідентифікатору для усіх користувачів
  [Tags]   ${USERS.user['${tender_owner}'].broker}: Пошук тендера другого етапу
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      get_second_stage
  ...      critical
  Можливість знайти тендер другого етапу по ідентифікатору для усіх користувачів


Відображення заголовку тендера другого етапу
  [Tags]   ${USERS.user['${tender_owner}'].broker}: Відображення основних даних тендера другого етапу
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      compare_stages
  ...      critical
  Отримати дані із поля title тендера другого етапу для усіх користувачів


Відображення мінімального кроку закупівлі другого етапу
  [Tags]   ${USERS.user['${tender_owner}'].broker}: Відображення основних даних тендера другого етапу
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      compare_stages
  ...      critical
  Отримати дані із поля minimalStep.amount тендера другого етапу для усіх користувачів


Відображення доступного бюджету закупівлі другого етапу
  [Tags]   ${USERS.user['${tender_owner}'].broker}: Відображення основних даних тендера другого етапу
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      compare_stages
  ...      critical
  Отримати дані із поля value.amount тендера другого етапу для усіх користувачів


Відображення опису закупівлі другого етапу
  [Tags]   ${USERS.user['${tender_owner}'].broker}: Відображення основних даних тендера другого етапу
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      compare_stages
  ...      non-critical
  Отримати дані із поля description тендера другого етапу для усіх користувачів


Відображення імені замовника тендера для другого етапу
  [Tags]   ${USERS.user['${tender_owner}'].broker}: Відображення основних даних тендера другого етапу
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      compare_stages
  ...      critical
  Отримати дані із поля procuringEntity.name тендера другого етапу для усіх користувачів


Відображення початку періоду прийому пропозицій тендера другого етапу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера другого етапу
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      compare_stages
  ...      critical
  Отримати дані із поля tenderPeriod.startDate тендера другого етапу для усіх користувачів


Відображення закінчення періоду прийому пропозицій тендера другого етапу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера другого етапу
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      compare_stages
  ...      critical
  Отримати дані із поля tenderPeriod.endDate тендера другого етапу для усіх користувачів

###################################################################
#           Відображення посилання на аукціон
###################################################################

Можливість вичитати посилання на аукціон для глядача
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      auction_url_viewer
  ...      critical
  Дочекатись дати закінчення прийому пропозицій  ${viewer}  ${TENDER['TENDER_UAID']}
  Дочекатись дати початку періоду аукціону  ${viewer}  ${TENDER['TENDER_UAID']}
  Можливість отримати посилання на аукціон для глядача


Можливість вичитати посилання на аукціон для першого учасника
  [Tags]   ${USERS.users['${provider}'].broker}: Процес аукціону
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      auction_url_provider
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Можливість отримати посилання на аукціон для учасника ${provider}


Можливість вичитати посилання на аукціон для другого учасника
  [Tags]   ${USERS.users['${provider1}'].broker}: Процес аукціону
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      auction_url_provider1
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider1}
  Можливість отримати посилання на аукціон для учасника ${provider1}


Можливість вичитати посилання на аукціон для третього учасника
  [Tags]   ${USERS.users['${provider2}'].broker}: Процес аукціону
  ...      provider1
  ...      ${USERS.users['${provider2}'].broker}
  ...      auction_url_provider2
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider2}
  Можливість отримати посилання на аукціон для учасника ${provider2}


##############################################################################################
#             Відображення основних даних лоту для другого етапу
##############################################################################################

Відображення лоту тендера другого етапу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера другого етапу
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      compare_lots_stages
  ...      critical
  Звірити відображення поля title усіх лотів другого етапу для усіх користувачів


Відображення опису лотів для тендера другого етапу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера другого етапу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      compare_lots_stages
  ...      non-critical
  Звірити відображення поля description усіх лотів другого етапу для користувача ${viewer}


Відображення бюджету лотів для тендера другого етапу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера другого етапу
  ...      viewer tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      compare_lots_stages
  ...      critical
  Звірити відображення поля value.amount усіх лотів другого етапу для усіх користувачів


Відображення валюти лотів для тендера другого етапу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера другого етапу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      compare_lots_stages
  ...      critical
  Звірити відображення поля value.currency усіх лотів другого етапу для користувача ${viewer}


Відображення ПДВ в бюджеті лотів для тендера другого етапу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера другого етапу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      compare_lots_stages
  ...      non-critical
  Звірити відображення поля value.valueAddedTaxIncluded усіх лотів другого етапу для користувача ${viewer}


Відображення мінімального кроку лотів для тендера другого етапу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера другого етапу
  ...      viewer tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      compare_lots_stages
  ...      non-critical
  Звірити відображення поля minimalStep.amount усіх лотів другого етапу для усіх користувачів


Відображення валюти мінімального кроку лотів для тендера другого етапу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера другого етапу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      compare_lots_tages
  ...      non-critical
  Звірити відображення поля minimalStep.currency усіх лотів другого етапу для користувача ${viewer}


Відображення ПДВ в мінімальному кроці лотів для тендера другого етапу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера другого етапу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      compare_lots_stages
  ...      non-critical
  Звірити відображення поля minimalStep.valueAddedTaxIncluded усіх лотів другого етапу для користувача ${viewer}

##############################################################################################
#             SECOND STAGE
##############################################################################################

Можливість подати пропозицію першим учасником на другому етапі
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_by_provider_second_stage
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію на другий етап користувачем ${provider}


Можливість подати пропозицію другим учасником на другому етапі
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції на другий етап
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_provider1_second_stage
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію на другий етап користувачем ${provider1}


Можливість подати пропозицію першим учасником на другому етапі
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_with_criteria_by_provider_second_stage
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію на другий етап конкурентного діалогу користувачем  ${provider}
  Можливість завантажити документ в пропозицію користувачем ${provider}
  Можливість додати до пропозиції відповідь на критерії користувачем ${provider}
  Можливість активувати пропозицію користувачем ${provider}


Можливість подати пропозицію другим учасником на другому етапі
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції на другий етап
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_with_criteria_by_provider1_second_stage
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію на другий етап конкурентного діалогу користувачем  ${provider1}
  Можливість завантажити документ в пропозицію користувачем ${provider1}
  Можливість додати до пропозиції відповідь на критерії користувачем ${provider1}
  Можливість активувати пропозицію користувачем ${provider1}


Можливість подати пропозицію третім учасником на другому етапі
  [Tags]   ${USERS.users['${provider2}'].broker}: Подання пропозиції на другий етап
  ...      provider2
  ...      ${USERS.users['${provider2}'].broker}
  ...      make_bid_with_criteria_by_provider2_second_stage
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію на другий етап конкурентного діалогу користувачем  ${provider2}
  Можливість завантажити документ в пропозицію користувачем ${provider2}
  Можливість додати до пропозиції відповідь на критерії користувачем ${provider2}
  Можливість активувати пропозицію користувачем ${provider2}


Можливість підтвердити першу пропозицію кваліфікації на другому етапі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація на другому етапі
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_first_bid_second_stage
  [Setup]  Дочекатись дати початку періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити 0 пропозицію кваліфікації


Можливість завантажити документ у кваліфікацію пропозиції другого учасника на другогму етапі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_add_doc_to_second_bid_second_stage
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ у кваліфікацію 1 пропозиції


Можливість відповісти на критерії Замовника у кваліфікацію пропозиції другого учасника на другогму етапі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_add_criteria_response_second_bid_second_stage
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Відповісти на критерії Замовника 1 пропозиції


Можливість відхилити другу пропозицію кваліфікації на другогму етапі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_reject_second_bid_second_stage
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відхилити 1 пропозиції кваліфікації


Можливість підтвердити другу пропозицію кваліфікації на другогму етапі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація на другому етапі
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_second_bid_second_stage
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити 1 пропозицію кваліфікації


Можливість підтвердити третю пропозицію кваліфікації на другогму етапі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація на другому етапі
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_third_bid_second_stage
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити 2 пропозицію кваліфікації


Можливість затвердити остаточне рішення кваліфікації на другому етапі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація на другому етапі
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_qualifications_second_stage
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість затвердити остаточне рішення кваліфікації

##############################################################################################
#             Document Service
##############################################################################################

Перевірка завантаження документів до тендера через Document Service
  [Tags]   ${USERS.users['${viewer}'].broker}: Document Service
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      document_service
  ...      critical
  Можливість перевірити завантаження документів через Document Service

##############################################################################################
#             CRITERIA
##############################################################################################

Можливість архівувати критерій
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Архівування критерія
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  cancel_criteria
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати -2 критерій


Можилвість активувати критерій
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Активація критерія
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  active_criteria
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість активувати -2 критерій


Можливість внести зміни в evidence критерія OTHER
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Внесення змін в eligibleEvidences критерія
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  patch_criteria_other_evidence
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити eligibleEvidences -1 критерія


Можливість перевірити зміну статуса на cancelled критерія OTHER
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Відображення зміни статуса вимоги критреія
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  patch_criteria_other_evidence_view
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість звірити статус cancelled -1 критерія 0 групи вимог 0 вимоги


Можливість перевірити статус active нової вимоги критерія OTHER
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Відображення статуса нової вимоги критреія
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  patch_criteria_other_evidence_view
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість звірити статус active -1 критерія 0 групи вимог 1 вимоги


Відображення наявності поля dateModified вимоги критерія OTHER
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Відображення наявності поля dateModified вимоги критреія
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  patch_criteria_other_evidence_view
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Отримати дані із поля dateModified -1 критерія 0 групи вимог 0 вимоги


Можливість перевірити чи однакові id у скасованої та нової вимоги критерія OTHER
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Перевірити що id у скасованої та нової вимоги критерія однакові
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  patch_criteria_other_evidence_view
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість звірити поля id -1 критерія 0 групи вимог 0 та 1 вимог


Можливість внести зміни в evidence критерія EXCLUSION
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Внесення змін в eligibleEvidences критерія
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  patch_criteria_exclusion_evidence
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити eligibleEvidences 0 критерія


Можливість перевірити зміну статуса на cancelled критерія EXCLUSION
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Відображення зміни статуса вимоги критреія
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  patch_criteria_exclusion_evidence_view
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість звірити статус cancelled 0 критерія 0 групи вимог 0 вимоги


Можливість перевірити статус active нової вимоги критерія EXCLUSION
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Відображення статуса нової вимоги критреія
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  patch_criteria_exclusion_evidence_view
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість звірити статус active 0 критерія 0 групи вимог 1 вимоги


Відображення наявності поля dateModified вимоги критерія EXCLUSION
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Відображення наявності поля dateModified вимоги критреія
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  patch_criteria_exclusion_evidence_view
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Отримати дані із поля dateModified 0 критерія 0 групи вимог 0 вимоги


Можливість перевірити чи однакові id у скасованої та нової вимоги критерія EXCLUSION
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Перевірити що id у скасованої та нової вимоги критерія однакові
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  patch_criteria_exclusion_evidence_view
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість звірити поля id 0 критерія 0 групи вимог 0 та 1 вимог