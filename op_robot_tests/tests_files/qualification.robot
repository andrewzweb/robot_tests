*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
@{USED_ROLES}   tender_owner  viewer  provider  provider1  provider2

${award_index}      ${0}


*** Test Cases ***
##############################################################################################
#             FIND TENDER
##############################################################################################

Можливість знайти закупівлю по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      find_tender  level1
  ...      critical
  Завантажити дані про тендер
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \   ${resp}=  Run As  ${username}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

##############################################################################################
#             CLAIMS
##############################################################################################

Можливість створити вимогу про виправлення визначення переможця, додати до неї документацію і подати її користувачем
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  create_award_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${award_index}=  Convert to integer  ${award_index}
  Можливість створити вимогу про виправлення визначення ${award_index} переможця із документацією


Відображення опису вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_award_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.claim.data.description} для користувача ${viewer}


Відображення ідентифікатора вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_award_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля complaintID вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.complaintID} для користувача ${viewer}


Відображення заголовку вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_award_claim
  Звірити відображення поля title вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.claim.data.title} для користувача ${viewer}


Відображення заголовку документації вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_award_claim
  ${right}=  Run As  ${viewer}  Отримати інформацію із документа до скарги
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}'].claim_data.complaintID}
  ...      ${USERS.users['${provider}'].claim_data.doc_id}
  ...      title
  ...      ${award_index}
  Порівняти об'єкти  ${USERS.users['${provider}'].claim_data.doc_name}  ${right}


Відображення вмісту документа до вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_award_claim
  Звірити відображення вмісту документа ${USERS['${provider}'].claim_data.doc_id} до скарги ${USERS.users['${provider}'].claim_data.complaintID} з ${USERS['${provider}'].claim_data.doc_content} для користувача ${viewer}


Відображення поданого статусу вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_award_claim
  ${status}=  Set variable if  'open' in '${MODE}'  pending  claim
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із ${status} для користувача ${viewer}


Можливість відповісти на вимогу про виправлення визначення переможця
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес оскарження
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  answer_award_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти resolved на вимогу про виправлення визначення ${award_index} переможця


Відображення статусу 'answered' вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  answer_award_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із answered для користувача ${viewer}


Відображення типу вирішення вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  answer_award_claim
  Звірити відображення поля resolutionType вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${tender_owner}'].claim_data.claim_answer.data.resolutionType} для користувача ${viewer}


Відображення вирішення вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  answer_award_claim
  Звірити відображення поля resolution вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${tender_owner}'].claim_data.claim_answer.data.resolution} для користувача ${viewer}


Можливість підтвердити задоволення вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  resolve_award_claim
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Можливість підтвердити задоволення вимоги про виправлення визначення ${award_index} переможця


Відображення статусу 'resolved' вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  resolve_award_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із resolved для користувача ${viewer}


Відображення задоволення вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  resolve_award_claim
  Звірити відображення поля satisfied вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.claim_answer_confirm.data.satisfied} для користувача ${viewer}


Можливість перетворити вимогу про виправлення визначення переможця в скаргу
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  escalate_award_claim
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Можливість перетворити вимогу про виправлення визначення ${award_index} переможця в скаргу


Відображення статусу 'pending' після 'claim -> answered' вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  escalate_award_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із pending для користувача ${viewer}


Відображення незадоволення вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  escalate_award_claim
  Звірити відображення поля satisfied вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.escalation.data.satisfied} для користувача ${viewer}


Можливість скасувати вимогу/скаргу про виправлення визначення переможця
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  cancel_award_claim
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Можливість скасувати вимогу в статусі draft про виправлення визначення ${award_index} переможця


Відображення скасованого статусу вимоги/скарги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  cancel_award_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${status}=  Set variable if  'open' in '${MODE}'  stopping  cancelled
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із ${status} для користувача ${viewer}


Відображення причини скасування вимоги/скарги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  cancel_award_claim
  Звірити відображення поля cancellationReason вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.cancellation.data.cancellationReason} для користувача ${viewer}

##############################################################################################
#             24 HOURS/ALP
##############################################################################################

Дочекатись початку періоду кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Очікування початку періоду кваліфікації учасників
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      wait_active_qualification_start
  Дочекатись дати початку періоду кваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}


Дочекатись перевірки кваліфікації на наявність milestones
  [Tags]   ${USERS.users['${tender_owner}'].broker}:
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      wait_to_check_milestones
  Дочекатися перевірки наявності milestones  ${tender_owner}  ${TENDER['TENDER_UAID']}


Повідомити учасника про невідповідність в тендерній пропозиції
  [Tags]   ${USERS.users['${tender_owner}'].broker}:
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_24h_milestone_qualification
  Повідомлення в awards про невіповідність пропозиції 0


Неможливість визначити переможця до завершення dueDate
  [Tags]   ${USERS.users['${tender_owner}'].broker}:
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      qualification_approve_award_dueDate_error
  run keyword and expect error  *  Підтвердити постачальника  ${tender_owner}  ${TENDER['TENDER_UAID']}  0


Можливість завантажити документ в пропозицію учасником 24 години
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_doc_to_bid_by_provider_24h_qualification
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ для усунення невідповідності в пропозиції в awards 0 користувачем ${provider}


Можливість змінити документацію цінової пропозиції першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_doc_to_bid_by_provider_24h_qualification
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити документацію цінової пропозиції при усуненні невідповідності користувачем ${provider}


Можливість завантажити документ в пропозицію учасником аномально низька ціна
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_doc_to_bid_by_provider_alp_qualification
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити обгрунтування аномально низької ціни до пропозиції учасником  ${provider}  documents  evidence


Можливість змінити документацію цінової пропозиції учасником аномально низька ціна
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      change_doc_to_bid_by_provider_alp_qualification
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити документацію обгрунтування аномально низької ціни користувачем ${provider}

##############################################################################################
#             QUALIFICATION
##############################################################################################

Можливість дочекатися перевірки переможців по ЄДРПОУ
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Перевірка користувача по ЄДРПОУ
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      qualifications_check_by_edrpou
  [Setup]  Дочекатись дати початку періоду кваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Дочекатися перевірки кваліфікацій  ${tender_owner}  ${TENDER['TENDER_UAID']}


Можливість завантажити документ рішення кваліфікаційної комісії для підтвердження постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_add_doc_to_first_award
  ...  critical
  [Setup]  Дочекатись дати початку періоду кваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  ${file_path}  ${file_name}  ${file_content}=   create_fake_doc
  Run As   ${tender_owner}   Завантажити документ рішення кваліфікаційної комісії   ${file_path}   ${TENDER['TENDER_UAID']}   0
  Remove File  ${file_path}


Можливість відповісти на критерії Замовника у кваліфікацію першого постачальника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      qualification_add_criteria_response_first_award
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Відповісти на критерії Замовника 0 постачальника


Можливість підтвердити постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_approve_first_award
  ...  critical
  [Setup]  Дочекатись дати початку періоду кваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  0


Можливість скасувати рішення кваліфікації
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_cancel_first_award_qualification
  ...  critical
  Run As  ${tender_owner}  Скасування рішення кваліфікаційної комісії  ${TENDER['TENDER_UAID']}  0


Можливість відхилити першого постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_reject_first_award
  ...  critical
  Run As  ${tender_owner}  Дискваліфікувати постачальника  ${TENDER['TENDER_UAID']}  0


Можливість відхилити постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_reject_second_award
  ...  critical
  Run As  ${tender_owner}  Дискваліфікувати постачальника  ${TENDER['TENDER_UAID']}  1


Можливість завантажити документ рішення кваліфікаційної комісії для підтвердження другого постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_add_doc_to_second_award
  ...  critical
  ${file_path}  ${file_name}  ${file_content}=   create_fake_doc
  Run As   ${tender_owner}   Завантажити документ рішення кваліфікаційної комісії   ${file_path}   ${TENDER['TENDER_UAID']}   1
  Remove File  ${file_path}


Можливість відповісти на критерії Замовника у кваліфікацію другого постачальника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      qualification_add_criteria_response_second_award
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Відповісти на критерії Замовника 1 постачальника


Можливість підтвердити другого постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_approve_second_award
  ...  critical
  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  1


Можливість завантажити документ рішення кваліфікаційної комісії для підтвердження третього постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_add_doc_to_third_award
  ...  critical
  ${file_path}  ${file_name}  ${file_content}=   create_fake_doc
  Run As   ${tender_owner}   Завантажити документ рішення кваліфікаційної комісії   ${file_path}   ${TENDER['TENDER_UAID']}   2
  Remove File  ${file_path}


Можливість відповісти на критерії Замовника у кваліфікацію третього постачальника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      qualification_add_criteria_response_third_award
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Відповісти на критерії Замовника 2 постачальника


Можливість підтвердити третього постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_approve_third_award
  ...  critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  2


Можливість завантажити документ рішення кваліфікаційної комісії для підтвердження четвертого постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_add_doc_to_fourth_award
  ...  critical
  ${file_path}  ${file_name}  ${file_content}=   create_fake_doc
  Run As   ${tender_owner}   Завантажити документ рішення кваліфікаційної комісії   ${file_path}   ${TENDER['TENDER_UAID']}   3
  Remove File  ${file_path}


Можливість підтвердити четвертого постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_approve_fourth_award
  ...  critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  3


Можливість затвердити остаточне рішення кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      qualification_approve_qualifications
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run As  ${tender_owner}  Затвердити постачальників  ${TENDER['TENDER_UAID']}


Можливість дочекатися перевірки переможців по ДФС
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Перевірка користувача по ДФС
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      awards_check_by_dfs
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатися перевірки кваліфікацій ДФС  ${tender_owner}  ${TENDER['TENDER_UAID']}

##############################################################################################
#             AWARDING
##############################################################################################

Дочекатись початку періоду підписання угоди
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Очікування початку періоду підписання угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      wait_active_awarding_start
  Дочекатись дати початку періоду підписання угоди  ${tender_owner}  ${TENDER['TENDER_UAID']}


Можливість додати підтверждення гарантії контракту
  [Tags]   Процес кваліфікації
  ...      qualification_add_contract_guarantee_document
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${username}=   Отримати поточного переможця тендерної поцедури  ${TENDER['TENDER_UAID']}  ${provider}  ${provider1}  ${provider2}
  Можливість завантажити підтвердження виконання контракту в пропозицію учасника  ${username}  ${TENDER['TENDER_UAID']}