/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.surveys;

import com.registryKit.activityCode.activityCodeManager;
import com.registryKit.activityCode.activityCodes;
import com.registryKit.client.clientManager;
import com.registryKit.client.engagementManager;
import com.registryKit.hierarchy.hierarchyManager;
import com.registryKit.hierarchy.programHierarchyDetails;
import com.registryKit.survey.SurveyPages;
import com.registryKit.survey.SurveyQuestionChoices;
import com.registryKit.survey.SurveyQuestions;
import com.registryKit.survey.submittedSurveyDocuments;
import com.registryKit.survey.submittedSurveys;
import com.registryKit.survey.submittedsurveycontentcriteria;
import com.registryKit.survey.survey;
import com.registryKit.survey.surveyManager;
import com.registryKit.survey.surveyQuestionAnswers;
import com.registryKit.survey.surveys;
import com.registryKit.user.User;
import com.registryKit.user.userManager;
import com.registryKit.user.userProgramModules;
import com.rr.missouri.ui.districts.district;
import com.rr.missouri.ui.districts.school;
import com.rr.missouri.ui.security.decryptObject;
import com.rr.missouri.ui.security.encryptObject;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.Objects;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.commons.lang3.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

/**
 *
 * @author chadmccue
 */
@Controller
@RequestMapping("/surveys")
public class surveyController {

    private static Integer moduleId = 11;

    @Autowired
    private clientManager clientmanager;

    @Autowired
    private surveyManager surveyManager;

    @Autowired
    private engagementManager engagementmanager;

    @Autowired
    private hierarchyManager hierarchymanager;

    @Autowired
    private activityCodeManager activitycodemanager;

    @Autowired
    private userManager usermanager;

    @Value("${programId}")
    private Integer programId;

    @Value("${topSecret}")
    private String topSecret;

    private static List<surveys> surveys;

    private static boolean allowCreate = false;
    private static boolean allowEdit = false;
    private static boolean allowDelete = false;

    /**
     * The '' request will display the list of taken surveys.
     *
     * @param request
     * @param response
     * @return	the administrator dashboard view
     * @throws Exception
     */
    @RequestMapping(value = "", method = RequestMethod.GET)
    public ModelAndView listSubmittedSurveys(@RequestParam(value = "i", required = false) String i, @RequestParam(value = "v", required = false) String v, HttpSession session) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/surveys");

        /* Get a list of surveys  */
        List<surveys> surveyList = surveyManager.getProgramSurveys(programId);

        encryptObject encrypt = new encryptObject();
        Map<String, String> map;

        for (surveys survey : surveyList) {
            //Encrypt the use id to pass in the url
            map = new HashMap<String, String>();
            map.put("id", Integer.toString(survey.getId()));
            map.put("topSecret", topSecret);

            String[] encrypted = encrypt.encryptObject(map);

            survey.setEncryptedId(encrypted[0]);
            survey.setEncryptedSecret(encrypted[1]);

        }
        surveys = surveyList;
        mav.addObject("surveys", surveyList);

        Integer surveyId;

        /* Get the submitted surveys for the selected survey type */
        if (!"".equals(i) && i != null && !"".equals(v) && v != null) {
            /* Decrypt the url */
            decryptObject decrypt = new decryptObject();

            Object obj = decrypt.decryptObject(i, v);

            String[] result = obj.toString().split((","));

            surveyId = Integer.parseInt(result[0].substring(4));

        } else {
            if (surveyList.size() > 0) {
                surveyId = surveyList.get(0).getId();
            } else {
                surveyId = 0;
            }

        }
        mav.addObject("selSurvey", surveyId);

        surveys surveyDetails = surveyManager.getSurveyDetails(surveyId);
        mav.addObject("surveyName", surveyDetails.getTitle());

        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");

        List<submittedSurveys> submittedSurveys = surveyManager.getEntitySurveys(userDetails, surveyId);

        /* Need to get the selected entities */
        if (submittedSurveys != null && !submittedSurveys.isEmpty()) {

            for (submittedSurveys survey : submittedSurveys) {

                //Encrypt the use id to pass in the url
                map = new HashMap<String, String>();
                map.put("id", Integer.toString(survey.getId()));
                map.put("topSecret", topSecret);

                String[] encrypted = encrypt.encryptObject(map);

                survey.setEncryptedId(encrypted[0]);
                survey.setEncryptedSecret(encrypted[1]);

            }
        }

        mav.addObject("submittedSurveys", submittedSurveys);

        /* Get user permissions */
        userProgramModules modulePermissions = usermanager.getUserModulePermissions(programId, userDetails.getId(), moduleId);
        if (userDetails.getRoleId() == 2) {
            allowCreate = true;
            allowEdit = true;
            allowDelete = true;
        } else {
            allowCreate = modulePermissions.isAllowCreate();
            allowEdit = modulePermissions.isAllowEdit();
            allowDelete = modulePermissions.isAllowDelete();
        }

        mav.addObject("allowCreate", allowCreate);
        mav.addObject("allowEdit", allowEdit);
        mav.addObject("allowDelete", allowDelete);

        return mav;
    }

    /**
     * The '/startSurvey' GET request will build out the survey and display the first page of the survey.
     *
     * @param i The encrypted client id
     * @param v The encrypted decryption key
     * @param s The id of the selected survey
     *
     * @param session
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/startSurvey", method = RequestMethod.POST)
    public ModelAndView startSurvey(@RequestParam(value = "s", required = false) String s, 
            @RequestParam(value = "i", required = false) String i, @RequestParam(value = "v", required = false) String v,
            @RequestParam(value = "selectedEntities", required = false) List<Integer> selectedEntities, HttpSession session) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/takeSurvey");
        mav.addObject("surveys", surveys);

        //Set the survey answer array to get ready to hold data
        if(session.getAttribute("questionAnswers") != null) {
            session.removeAttribute("questionAnswers");
        }
        session.setAttribute("questionAnswers", new ArrayList<surveyQuestionAnswers>());
        
        if(session.getAttribute("selectedContentCriterias") != null) {
            session.removeAttribute("selectedContentCriterias");
        }
        session.setAttribute("selectedContentCriterias", new ArrayList<surveyContentCriteria>());
        
        if(session.getAttribute("districtList") != null) {
            session.removeAttribute("districtList");
        }
        session.setAttribute("districtList", new ArrayList<district>());
        
        if(session.getAttribute("seenPages") != null) {
            session.removeAttribute("seenPages");
        }
        session.setAttribute("seenPages", new ArrayList<Integer>());
        
        int clientId = 0;
        int surveyId = 0;
        
         /* Get the submitted surveys for the selected survey type */
        if (!"".equals(i) && i != null && !"".equals(v) && v != null) {
            /* Decrypt the url */
            decryptObject decrypt = new decryptObject();

            Object obj = decrypt.decryptObject(i, v);

            String[] result = obj.toString().split((","));

            surveyId = Integer.parseInt(result[0].substring(4));

        } else {
            surveyId = Integer.parseInt(s);
        }


        if (surveyId > 0) {

            surveys surveyDetails = surveyManager.getSurveyDetails(surveyId);

            /* Make sure the survey is part of this program and active */
            if (surveyDetails.getProgramId() != programId || surveyDetails.getStatus() == false) {

                /* Redirect back to the survey list page */
            } /* Set up the survey */ else {
                survey survey = new survey();
                survey.setClientId(clientId);
                survey.setSurveyId(surveyId);
                survey.setSurveyTitle(surveyDetails.getTitle());
                survey.setPrevButton(surveyDetails.getPrevButtonText());
                survey.setNextButton(surveyDetails.getNextButtonText());
                survey.setSaveButton(surveyDetails.getDoneButtonText());
                survey.setSubmittedSurveyId(0);

                encryptObject encrypt = new encryptObject();
                Map<String, String> map;

                map = new HashMap<String, String>();
                map.put("id", Integer.toString(surveyId));
                map.put("topSecret", topSecret);

                String[] encrypted = encrypt.encryptObject(map);

                survey.setEncryptedId(encrypted[0]);
                survey.setEncryptedSecret(encrypted[1]);

                /* Get the pages */
                List<SurveyPages> surveyPages = surveyManager.getSurveyPages(surveyId, false, 0, 0, 0);
                SurveyPages currentPage = surveyManager.getSurveyPage(surveyId, true, 1, clientId, 0, 0, 0, 0);
                survey.setPageTitle(currentPage.getPageTitle());
                survey.setPageDesc(currentPage.getPageDesc());
                survey.setSurveyPageQuestions(currentPage.getSurveyQuestions());
                survey.setTotalPages(surveyPages.size());
                survey.setPageId(currentPage.getId());
                survey.setLastPageId(surveyPages.get(surveyPages.size() - 1).getId());

                mav.addObject("survey", survey);
                mav.addObject("surveyPages", surveyPages);
            }
        } else {
            /* Redirect back to the survey list page */

        }

        User userDetails = (User) session.getAttribute("userDetails");

        /* Get a list of available schools for the selected districts */
        if (selectedEntities != null && !selectedEntities.isEmpty() && !"".equals(selectedEntities)) {
            
            encryptObject encrypt = new encryptObject();
            Map<String, String> map;
            
            List<district> districtList = (List<district>)session.getAttribute("districtList");
            
            for (Integer entity : selectedEntities) {

                List<school> schoolList = new ArrayList<school>();

                district district = new district();
                district.setDistrictId(entity);

                programHierarchyDetails districtDetails = hierarchymanager.getProgramHierarchyItemDetails(entity);
                district.setDistrictName(districtDetails.getName());

                Integer userId = 0;
                if (userDetails.getRoleId() == 3) {
                    userId = userDetails.getId();
                }

                List schools = hierarchymanager.getProgramOrgHierarchyItems(programId, 3, entity, userId);

                if (!schools.isEmpty() && schools.size() > 0) {

                    for (ListIterator iter = schools.listIterator(); iter.hasNext();) {

                        Object[] row = (Object[]) iter.next();

                        school school = new school();
                        school.setSchoolId(Integer.parseInt(row[0].toString()));
                        school.setSchoolName(row[1].toString());

                        //Encrypt the use id to pass in the url
                        map = new HashMap<String, String>();
                        map.put("id", Integer.toString(Integer.parseInt(row[0].toString())));
                        map.put("topSecret", topSecret);

                        String[] encrypted = encrypt.encryptObject(map);

                        school.setEncryptedId(encrypted[0]);
                        school.setEncryptedSecret(encrypted[1]);

                        schoolList.add(school);

                    }

                    district.setSchoolList(schoolList);

                }

                districtList.add(district);

            }

            mav.addObject("selDistricts", districtList);

        }

        mav.addObject("selSurvey", surveyId);

        mav.addObject("selectedEntities", selectedEntities.toString().replace("[", "").replace("]", ""));
        mav.addObject("currentPage", 1);

        mav.addObject("qNum", 0);
        mav.addObject("disabled", false);

        return mav;
    }

    /**
     * The '/editSurvey' GET request will build out the survey and display the first page of the survey.
     *
     * @param i The encrypted survey id
     * @param v The encrypted decryption key
     *
     * @param session
     * @return
     * @throws Exception
     */
    @RequestMapping(value = {"/editSurvey", "/viewSurvey"}, method = RequestMethod.GET)
    public ModelAndView editSurvey(@RequestParam String i, @RequestParam String v, HttpSession session, HttpServletRequest request) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/takeSurvey");
        mav.addObject("surveys", surveys);

        //Set the survey answer array to get ready to hold data
        if(session.getAttribute("questionAnswers") != null) {
            session.removeAttribute("questionAnswers");
        }
        session.setAttribute("questionAnswers", new ArrayList<surveyQuestionAnswers>());
        
        if(session.getAttribute("selectedContentCriterias") != null) {
            session.removeAttribute("selectedContentCriterias");
        }
        session.setAttribute("selectedContentCriterias", new ArrayList<surveyContentCriteria>());
        
        if(session.getAttribute("districtList") != null) {
            session.removeAttribute("districtList");
        }
        session.setAttribute("districtList", new ArrayList<district>());
        
        if(session.getAttribute("seenPages") != null) {
            session.removeAttribute("seenPages");
        }
        session.setAttribute("seenPages", new ArrayList<Integer>());
        
        int clientId = 0;

        /* Decrypt the url */
        decryptObject decrypt = new decryptObject();

        Object obj = decrypt.decryptObject(i, v);

        String[] result = obj.toString().split((","));

        int submittedSurveyId = Integer.parseInt(result[0].substring(4));

        /* Get the survey details */
        submittedSurveys submittedSurveyDetails = surveyManager.getSubmittedSurvey(submittedSurveyId);

        surveys surveyDetails = surveyManager.getSurveyDetails(submittedSurveyDetails.getSurveyId());

        User userDetails = (User) session.getAttribute("userDetails");

        survey survey = new survey();
        survey.setClientId(clientId);
        survey.setSurveyId(submittedSurveyDetails.getSurveyId());
        survey.setSurveyTitle(surveyDetails.getTitle());
        survey.setPrevButton(surveyDetails.getPrevButtonText());
        survey.setNextButton(surveyDetails.getNextButtonText());
        survey.setSaveButton(surveyDetails.getDoneButtonText());
        survey.setSubmittedSurveyId(submittedSurveyId);
        survey.setEntityIds(surveyManager.getSubmittedSurveyEntities(submittedSurveyId, userDetails));

        encryptObject encrypt = new encryptObject();
        Map<String, String> map;

        //Encrypt the use id to pass in the url
        map = new HashMap<String, String>();
        map.put("id", Integer.toString(submittedSurveyDetails.getSurveyId()));
        map.put("topSecret", topSecret);

        String[] encrypted = encrypt.encryptObject(map);

        survey.setEncryptedId(encrypted[0]);
        survey.setEncryptedSecret(encrypted[1]);

        /* Get the pages */
        List<SurveyPages> surveyPages = surveyManager.getSurveyPages(submittedSurveyDetails.getSurveyId(), false, 0, 0, 0);
        SurveyPages currentPage = surveyManager.getSurveyPage(submittedSurveyDetails.getSurveyId(), true, 1, clientId, 0, 0, submittedSurveyId, 0);
        survey.setPageTitle(currentPage.getPageTitle());
        survey.setPageDesc(currentPage.getPageDesc());
        survey.setSurveyPageQuestions(currentPage.getSurveyQuestions());
        survey.setTotalPages(surveyPages.size());
        survey.setLastPageId(surveyPages.get(surveyPages.size() - 1).getId());
        survey.setPageId(currentPage.getId());
        
        /* Need to update any date functions */
        if(survey.getSurveyPageQuestions() != null && survey.getSurveyPageQuestions().size() > 0) {
            for(SurveyQuestions question : survey.getSurveyPageQuestions()) {
                if(question.getAnswerTypeId() == 6) {
                    if (question.getQuestionValue().length() > 0 && !question.getQuestionValue().contains("^^^^^")) {
                       SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                       Date formattedDate = df.parse(question.getQuestionValue());

                       if(question.getDateFormatType() == 2) { //dd/mm/yyyy
                           df.applyPattern("dd/MM/yyyy");
                       }
                       else { //mm/dd/yyyy
                           df.applyPattern("MM/dd/yyyy");
                       }
                       String formattedDateasString = df.format(formattedDate);
                       question.setQuestionValue(formattedDateasString);
                    }
                }
            }
        }

        mav.addObject("survey", survey);
        mav.addObject("surveyPages", surveyPages);

        List<Integer> selectedEntities = surveyManager.getSurveyEntities(submittedSurveyId);

        /* Get a list of available schools for the selected districts */
        if (selectedEntities != null && !selectedEntities.isEmpty() && !"".equals(selectedEntities)) {
            
            List<district> districtList = (List<district>)session.getAttribute("districtList");
           
            for (Integer entityId : selectedEntities) {

                List<school> schoolList = new ArrayList<school>();

                district district = new district();
                district.setDistrictId(entityId);

                programHierarchyDetails districtDetails = hierarchymanager.getProgramHierarchyItemDetails(entityId);
                district.setDistrictName(districtDetails.getName());

                Integer userId = 0;
                if (userDetails.getRoleId() == 3) {
                    userId = userDetails.getId();
                }

                List schools = hierarchymanager.getProgramOrgHierarchyItems(programId, 3, entityId, userId);

                if (!schools.isEmpty() && schools.size() > 0) {

                    for (ListIterator iter = schools.listIterator(); iter.hasNext();) {

                        Object[] row = (Object[]) iter.next();

                        school school = new school();
                        school.setSchoolId(Integer.parseInt(row[0].toString()));
                        school.setSchoolName(row[1].toString());

                        //Encrypt the use id to pass in the url
                        map = new HashMap<String, String>();
                        map.put("id", Integer.toString(Integer.parseInt(row[0].toString())));
                        map.put("topSecret", topSecret);

                        String[] encrypted2 = encrypt.encryptObject(map);

                        school.setEncryptedId(encrypted2[0]);
                        school.setEncryptedSecret(encrypted2[1]);

                        schoolList.add(school);

                    }

                    district.setSchoolList(schoolList);

                }

                districtList.add(district);

            }

            mav.addObject("selDistricts", districtList);

        }

        mav.addObject("selSurvey", submittedSurveyDetails.getSurveyId());
        mav.addObject("selectedEntities", selectedEntities.toString().replace("[", "").replace("]", ""));

        mav.addObject("qNum", 0);

        boolean disabled = false;
        if ("/surveys/viewSurvey".equals(request.getServletPath())) {
            disabled = true;
        } 

        mav.addObject("disabled", disabled);

        return mav;
    }

    /**
     * The '/takeSurvey' POST request will submit the survey page.
     *
     * @param survey
     * @param session
     * @param redirectAttr
     * @param action
     * @param goToPage
     * @param disabled
     * @param selectedEntities
     * @param entityIds
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/submitSurvey", method = RequestMethod.POST)
    public ModelAndView saveSurveyPage(@ModelAttribute(value = "survey") survey survey, HttpSession session,
            RedirectAttributes redirectAttr, @RequestParam String action, @RequestParam Integer goToPage, @RequestParam(value = "entityIds", required = false) List<String> entityIds,
            @RequestParam(value = "selectedEntities", required = false) List<String> selectedEntities,
            @RequestParam(value = "disabled", required = true, defaultValue = "false") boolean disabled) throws Exception {

        Integer goToQuestion = 0;
        boolean skipToEnd = false;
        boolean submitted = false;
        
        ModelAndView mav = new ModelAndView();
        
        if (entityIds != null && !"".equals(entityIds) && !entityIds.isEmpty()) {
            List<Integer> entityIdList = new ArrayList<Integer>();

            for (String entityId : entityIds) {
                Integer entityIdasInt = Integer.parseInt(entityId);

                entityIdList.add(entityIdasInt);
            }
            survey.setEntityIds(entityIdList);
        }
        
        Integer lastQuestionSavedId = 0;

        if ("next".equals(action) || "done".equals(action) || "save".equals(action)) {
            goToPage = 0;
            Integer lastQuestionSaved = 0;
            List<SurveyQuestions> questions = survey.getSurveyPageQuestions();
            
            List<surveyQuestionAnswers> questionAnswers = (List<surveyQuestionAnswers>)session.getAttribute("questionAnswers");
            
            for (SurveyQuestions question : questions) {

                boolean questionFound = false;
                
                List<surveyQuestionAnswers> toRemove = new ArrayList<surveyQuestionAnswers>();
                
                if(questionAnswers != null && questionAnswers.size() > 0) {
                    
                    Iterator<surveyQuestionAnswers> it = questionAnswers.iterator();
                    
                    while (it.hasNext()) {
                        surveyQuestionAnswers questionAnswer = it.next();

                        if (questionAnswer.getQuestionId() == question.getId()) {

                            if ((question.getAnswerTypeId() == 1 || question.getAnswerTypeId() == 2) && question.getQuestionValue().contains(",")) {
                                toRemove.add(questionAnswer);
                            }
                            else {
                                questionFound = true;

                                if (question.getAnswerTypeId() == 1 || question.getAnswerTypeId() == 2) {
                                    SurveyQuestionChoices choiceDetails = surveyManager.getSurveyQuestionChoice(Integer.parseInt(question.getQuestionValue()));

                                    if (choiceDetails.getChoiceValue() > 0) {
                                        questionAnswer.setAnswerId(choiceDetails.getChoiceValue());
                                    } /*else {
                                        questionAnswer.setAnswerText(choiceDetails.getChoiceText());
                                    }*/
                                    questionAnswer.setAnswerText(choiceDetails.getChoiceText());

                                    if (choiceDetails.isSkipToEnd() == true) {
                                        skipToEnd = true;
                                        submitted = true;
                                    } else {
                                        if (choiceDetails.getSkipToPageId() > 0) {
                                            SurveyPages pageDetails = surveyManager.getSurveyPageDetails(choiceDetails.getSkipToPageId());
                                            goToPage = pageDetails.getPageNum();
                                        }

                                        goToQuestion = choiceDetails.getSkipToQuestionId();

                                        lastQuestionSavedId = question.getId();
                                    }

                                    questionAnswer.setAnswerOther(question.getQuestionOtherValue());

                                } else {
                                    questionAnswer.setAnswerText(question.getQuestionValue());
                                }

                                questionAnswer.setQuestionId(question.getId());
                                questionAnswer.setProgramPatientId(survey.getClientId());
                                questionAnswer.setProgramEngagementId(survey.getEngagementId());
                                questionAnswer.setqNum(question.getQuestionNum());
                                questionAnswer.setSurveyPageId(question.getSurveyPageId());
                                questionAnswer.setSaveToFieldId(question.getSaveToFieldId());
                                questionAnswer.setRelatedQuestionId(question.getRelatedQuestionId());
                            }
                        }
                    }
                }
                if(!toRemove.isEmpty()) {
                    questionAnswers.removeAll(toRemove);
                }

                if (questionFound == false) {

                    if ((question.getAnswerTypeId() == 1 || question.getAnswerTypeId() == 2) && !"".equals(question.getQuestionValue())) {
                        
                        if (question.getQuestionValue().contains(",")) {
                            String[] lineVector = question.getQuestionValue().split(",");
                            
                            for (int i = 0; i < lineVector.length; i++) {
                                surveyQuestionAnswers questionAnswer = new surveyQuestionAnswers();
                                Integer qAnsValue = Integer.parseInt(lineVector[i]);

                                SurveyQuestionChoices choiceDetails = surveyManager.getSurveyQuestionChoice(qAnsValue);

                                if (choiceDetails.getChoiceValue() > 0) {
                                    questionAnswer.setAnswerId(choiceDetails.getChoiceValue());
                                } /*else {
                                    questionAnswer.setAnswerText(choiceDetails.getChoiceText());
                                }*/
                                questionAnswer.setAnswerText(choiceDetails.getChoiceText());

                                if (choiceDetails.isSkipToEnd() == true) {
                                    skipToEnd = true;
                                    submitted = true;
                                } else {
                                    if (choiceDetails.getSkipToPageId() > 0) {
                                        SurveyPages pageDetails = surveyManager.getSurveyPageDetails(choiceDetails.getSkipToPageId());
                                        goToPage = pageDetails.getPageNum();
                                    }

                                    goToQuestion = choiceDetails.getSkipToQuestionId();
                                    
                                    lastQuestionSavedId = question.getId();
                                }

                                questionAnswer.setQuestionId(question.getId());
                                questionAnswer.setProgramPatientId(survey.getClientId());
                                questionAnswer.setProgramEngagementId(survey.getEngagementId());
                                questionAnswer.setqNum(question.getQuestionNum());
                                questionAnswer.setSurveyPageId(question.getSurveyPageId());
                                questionAnswer.setSaveToFieldId(question.getSaveToFieldId());
                                questionAnswer.setRelatedQuestionId(question.getRelatedQuestionId());

                                questionAnswers.add(questionAnswer);

                                if (i == 0) {
                                    questionAnswer.setAnswerOther(question.getQuestionOtherValue());
                                }

                            }

                        } else {
                            
                            surveyQuestionAnswers questionAnswer = new surveyQuestionAnswers();

                            boolean isInt = true;

                            try {
                                Integer.parseInt(question.getQuestionValue());
                            } catch (NumberFormatException e) {
                                isInt = false;
                            } catch (NullPointerException e) {
                                isInt = false;
                            }

                            if (isInt) {
                                SurveyQuestionChoices choiceDetails = surveyManager.getSurveyQuestionChoice(Integer.parseInt(question.getQuestionValue()));
                                if (choiceDetails.getChoiceValue() > 0) {
                                    questionAnswer.setAnswerId(choiceDetails.getChoiceValue());
                                } /*else {
                                    questionAnswer.setAnswerText(choiceDetails.getChoiceText());
                                }*/
                                questionAnswer.setAnswerText(choiceDetails.getChoiceText());


                                if (choiceDetails.isSkipToEnd() == true) {
                                    skipToEnd = true;
                                    submitted = true;
                                } else {
                                    if (choiceDetails.getSkipToPageId() > 0) {
                                        SurveyPages pageDetails = surveyManager.getSurveyPageDetails(choiceDetails.getSkipToPageId());
                                        goToPage = pageDetails.getPageNum();
                                    }

                                    goToQuestion = choiceDetails.getSkipToQuestionId();
                                    
                                    lastQuestionSavedId = question.getId();
                                }

                            } else {
                                questionAnswer.setAnswerText(question.getQuestionValue());
                            }
                            
                            questionAnswer.setAnswerOther(question.getQuestionOtherValue());
                            questionAnswer.setQuestionId(question.getId());
                            questionAnswer.setProgramPatientId(survey.getClientId());
                            questionAnswer.setProgramEngagementId(survey.getEngagementId());
                            questionAnswer.setqNum(question.getQuestionNum());
                            questionAnswer.setSurveyPageId(question.getSurveyPageId());
                            questionAnswer.setSaveToFieldId(question.getSaveToFieldId());
                            questionAnswer.setRelatedQuestionId(question.getRelatedQuestionId());

                            questionAnswers.add(questionAnswer);
                        }

                    } else {
                        surveyQuestionAnswers questionAnswer = new surveyQuestionAnswers();
                        
                        questionAnswer.setAnswerText(question.getQuestionValue());

                        questionAnswer.setQuestionId(question.getId());
                        questionAnswer.setProgramPatientId(survey.getClientId());
                        questionAnswer.setProgramEngagementId(survey.getEngagementId());
                        questionAnswer.setqNum(question.getQuestionNum());
                        questionAnswer.setSurveyPageId(question.getSurveyPageId());
                        questionAnswer.setSaveToFieldId(question.getSaveToFieldId());
                        questionAnswer.setRelatedQuestionId(question.getRelatedQuestionId());

                        questionAnswers.add(questionAnswer);
                    }

                }

                lastQuestionSaved = question.getQuestionNum();
            }

            /* Remove questions passed the last question answered */
            List<surveyQuestionAnswers> updatedquestionAnswers = (List<surveyQuestionAnswers>)session.getAttribute("questionAnswers");
            Iterator<surveyQuestionAnswers> itr = updatedquestionAnswers.iterator();

            while (itr.hasNext()) {
                surveyQuestionAnswers questionAnswer = itr.next();

                if (questionAnswer.getqNum() > lastQuestionSaved) {
                    itr.remove();
                }
            }

        }

        

        survey NextPage = new survey();
        NextPage.setClientId(survey.getClientId());
        NextPage.setSurveyId(survey.getSurveyId());
        NextPage.setSurveyTitle(survey.getSurveyTitle());
        NextPage.setPrevButton(survey.getPrevButton());
        NextPage.setNextButton(survey.getNextButton());
        NextPage.setSaveButton(survey.getSaveButton());
        NextPage.setSubmittedSurveyId(survey.getSubmittedSurveyId());
        NextPage.setEntityIds(survey.getEntityIds());

        SurveyPages currentPage = null;
        Integer qNum = 1;
        Integer nextPage = 1;

        /* Get the pages */
        List<SurveyPages> surveyPages = surveyManager.getSurveyPages(survey.getSurveyId(), false, 0, 0, 0);

        if ("prev".equals(action)) {
            mav.setViewName("/takeSurvey");
            
            List<Integer> seenPages = (List<Integer>)session.getAttribute("seenPages");
            
            nextPage = seenPages.get(seenPages.size() - 1);
            /* Remove this page from array */
            seenPages.remove(seenPages.size() - 1);

            currentPage = surveyManager.getSurveyPage(survey.getSurveyId(), true, nextPage, survey.getClientId(), 0, goToQuestion, survey.getSubmittedSurveyId(), lastQuestionSavedId);

            Integer totalPageQuestions = 0;
            
            List<surveyQuestionAnswers> questionAnswers = (List<surveyQuestionAnswers>)session.getAttribute("questionAnswers");
            
            for (SurveyQuestions question : currentPage.getSurveyQuestions()) {
                 question.setQuestionValue("");
                 if(questionAnswers != null && questionAnswers.size() > 0) {
                    
                    Iterator<surveyQuestionAnswers> it = questionAnswers.iterator();
                    
                    while (it.hasNext()) {
                        surveyQuestionAnswers questionAnswer = it.next();
                        
                         if (questionAnswer.getQuestionId() == question.getId()) {
                             if("".equals(question.getQuestionValue())) {
                                 question.setQuestionValue(questionAnswer.getAnswerText());
                             }
                             else {
                                 String currValue = question.getQuestionValue();
                                 currValue+=",";
                                 currValue += questionAnswer.getAnswerText();
                                 question.setQuestionValue(currValue);
                             }
                         }
                    }
                }
                
                if (question.getAnswerTypeId() != 7) {
                    totalPageQuestions += 1;
                }
            }

            qNum = (survey.getLastQNumAnswered() - totalPageQuestions) - 1;
        } else if ("next".equals(action)) {
            mav.setViewName("/takeSurvey");

            if (goToPage > 0) {
                nextPage = goToPage;
            } else {

                /* Check to see if page has any skip logic */
                SurveyPages currentPageDetails = surveyManager.getSurveyPageDetails(survey.getPageId());
                if (currentPageDetails.getSkipToPage() > 0) {
                    SurveyPages skiptoPageDetails = surveyManager.getSurveyPageDetails(currentPageDetails.getSkipToPage());
                    nextPage = skiptoPageDetails.getPageNum();
                } else if (currentPageDetails.getSkipToPage() == -1) {
                    skipToEnd = true;
                    submitted = true;
                } else {
                    nextPage = survey.getCurrentPage() + 1;
                }
            }
            
            List<Integer> seenPages = (List<Integer>)session.getAttribute("seenPages");
            seenPages.add(survey.getCurrentPage());

            currentPage = surveyManager.getSurveyPage(survey.getSurveyId(), true, nextPage, survey.getClientId(), 0, goToQuestion, survey.getSubmittedSurveyId(), lastQuestionSavedId);

            qNum = survey.getLastQNumAnswered();

        } else if ("save".equals(action)) {
            submitted = false;
        } else if ("done".equals(action)) {
            skipToEnd = true;
            submitted = true;
        }

        /**
         * If saving the survey, save and redirect to the survey list page *
         */
        if ("save".equals(action)) {
            User userDetails = (User) session.getAttribute("userDetails");

            /**
             * Submit answers to DB *
             */
            List<surveyQuestionAnswers> questionAnswers = (List<surveyQuestionAnswers>)session.getAttribute("questionAnswers");
            Integer submittedSurveyId = surveyManager.submitSurvey(userDetails.getId(), programId, survey, questionAnswers, submitted, selectedEntities);

            //if (surveyContentCriterias != null) {
            if(session.getAttribute("selectedContentCriterias") != null) {
                List<surveyContentCriteria> selectedContentCriteria = (List<surveyContentCriteria>)session.getAttribute("selectedContentCriterias");

                Iterator<surveyContentCriteria> it = selectedContentCriteria.iterator();

                /* Delete existing code sets */
                surveyManager.deleteSurveyCodeSets(submittedSurveyId);

                while (it.hasNext()) {

                    surveyContentCriteria criteria = it.next();

                    if (criteria.isChecked()) {
                        submittedsurveycontentcriteria savedCodeSets = new submittedsurveycontentcriteria();
                        savedCodeSets.setCodeId(criteria.getCodeId());
                        savedCodeSets.setEntityId(criteria.getSchoolId());
                        savedCodeSets.setSubmittedSurveyId(submittedSurveyId);

                        surveyManager.submitSurveyCodeSets(savedCodeSets);
                    }
                }
            }

            encryptObject encrypt = new encryptObject();
            Map<String, String> map;

            //Encrypt the use id to pass in the url
            map = new HashMap<String, String>();
            map.put("id", Integer.toString(survey.getSurveyId()));
            map.put("topSecret", topSecret);

            String[] encrypted = encrypt.encryptObject(map);
            
            mav = new ModelAndView(new RedirectView("/surveys?i=" + encrypted[0] + "&v=" + encrypted[1]));
        } /**
         * If reached the last page or an option was selected to skip to the end *
         */
        else if (currentPage == null || skipToEnd == true) {

            if (disabled == false) {
                User userDetails = (User) session.getAttribute("userDetails");

                /**
                 * Submit answers to DB *
                 */
                List<surveyQuestionAnswers> questionAnswers = (List<surveyQuestionAnswers>)session.getAttribute("questionAnswers");
                Integer submittedSurveyId = surveyManager.submitSurvey(userDetails.getId(), programId, survey, questionAnswers, submitted, selectedEntities);

                if (session.getAttribute("selectedContentCriterias") != null) {
                    List<surveyContentCriteria> selectedContentCriteria = (List<surveyContentCriteria>)session.getAttribute("selectedContentCriterias");

                    Iterator<surveyContentCriteria> it = selectedContentCriteria.iterator();

                    /* Delete existing code sets */
                    surveyManager.deleteSurveyCodeSets(submittedSurveyId);

                    while (it.hasNext()) {

                        surveyContentCriteria criteria = it.next();

                        if (criteria.isChecked()) {
                            submittedsurveycontentcriteria savedCodeSets = new submittedsurveycontentcriteria();
                            savedCodeSets.setCodeId(criteria.getCodeId());
                            savedCodeSets.setEntityId(criteria.getSchoolId());
                            savedCodeSets.setSubmittedSurveyId(submittedSurveyId);

                            surveyManager.submitSurveyCodeSets(savedCodeSets);
                        }
                    }
                }

                encryptObject encrypt = new encryptObject();
                Map<String, String> map;

                //Encrypt the use id to pass in the url
                map = new HashMap<String, String>();
                map.put("id", Integer.toString(survey.getSurveyId()));
                map.put("topSecret", topSecret);

                String[] encrypted = encrypt.encryptObject(map);

                mav.setViewName("/completedSurvey");
                surveys surveyDetails = surveyManager.getSurveyDetails(survey.getSurveyId());
                mav.addObject("surveyDetails", surveyDetails);
                
                List<district> districtList = (List<district>)session.getAttribute("districtList");
                mav.addObject("selDistricts", districtList);
                mav.addObject("surveys", surveys);
                mav.addObject("selectedEntities", selectedEntities.toString().replace("[", "").replace("]", ""));
                mav.addObject("i", encrypted[0]);
                mav.addObject("v", encrypted[1]);
                mav.addObject("submittedSurveyId", submittedSurveyId);
                
                /* Get a list of survey documents */
                List<submittedSurveyDocuments> surveyDocuments = surveyManager.getSubmittedSurveyDocuments(submittedSurveyId);

                if(surveyDocuments != null && surveyDocuments.size() > 0) {
                    for(submittedSurveyDocuments document : surveyDocuments) {
                        if(document.getUploadedFile() != null && !"".equals(document.getUploadedFile())) {
                            int index = document.getUploadedFile().lastIndexOf('.');
                            document.setFileExt(document.getUploadedFile().substring(index+1));
                            
                            if(document.getUploadedFile().length() > 60) {
                                String shortenedTitle = document.getUploadedFile().substring(0,30) + "..." + document.getUploadedFile().substring(document.getUploadedFile().length()-10, document.getUploadedFile().length());
                                document.setShortenedTitle(shortenedTitle);
                            }
                            document.setEncodedTitle(URLEncoder.encode(document.getUploadedFile(),"UTF-8"));
                            
                        }
                    }
                }
                

                mav.addObject("surveyDocuments", surveyDocuments);

                
            } else {

            }

        } else {
            
            NextPage.setPageTitle(currentPage.getPageTitle());
            NextPage.setPageDesc(currentPage.getPageDesc());
            NextPage.setSurveyPageQuestions(currentPage.getSurveyQuestions());
            NextPage.setPageId(currentPage.getId());
            
            /* Loop through to get actually question answers */
            
            List<surveyQuestionAnswers> questionAnswers = (List<surveyQuestionAnswers>)session.getAttribute("questionAnswers");
            Iterator<surveyQuestionAnswers> it = questionAnswers.iterator();
            
            for (SurveyQuestions question : currentPage.getSurveyQuestions()) {
                
                String questionValue = "";
                
                while (it.hasNext()) {
                    surveyQuestionAnswers questionAnswer = it.next();
                    
                    if (questionAnswer.getQuestionId() == question.getId()) {
                        
                        if (questionAnswer != null) {
                            if (questionAnswer.getAnswerId() > 0) {
                                questionValue += String.valueOf(questionAnswer.getAnswerId());
                            } else {
                                questionValue += questionAnswer.getAnswerText();
                            }

                            questionValue+=",";
                        }
                    }
                }
                
                if(!"".equals(questionValue)) {
                    question.setQuestionValue(StringEscapeUtils.escapeHtml3(questionValue.replaceAll("(,)*$", "")));
                }
            }

            NextPage.setTotalPages(surveyPages.size());
            NextPage.setCurrentPage(nextPage);
            NextPage.setLastPageId(surveyPages.get(surveyPages.size() - 1).getId());

            mav.addObject("survey", NextPage);
            mav.addObject("surveyPages", surveyPages);
            mav.addObject("qNum", qNum);
            mav.addObject("selectedEntities", selectedEntities);
            List<district> districtList = (List<district>)session.getAttribute("districtList");
            mav.addObject("selDistricts", districtList);
            mav.addObject("surveys", surveys);
            mav.addObject("disabled", disabled);
            mav.addObject("selSurvey", survey.getSurveyId());
        }

        return mav;
    }

    /**
     * The 'getEntityCodeSets' GET request will get all the code sets for the selected entities.
     *
     * @param entityId
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getEntityCodeSets", method = RequestMethod.GET)
    public @ResponseBody
    ModelAndView getEntityCodeSets(
            @RequestParam(value = "entityId", required = true) List<Integer> entityIdList, 
            @RequestParam(value = "surveyId", required = true) Integer surveyId,
            @RequestParam(value = "disabled", required = true) Boolean disabled,
            HttpSession session) throws Exception {

        List<surveyContentCriteria> selectedContentCriteria = (List<surveyContentCriteria>)session.getAttribute("selectedContentCriterias");
                
        for (Integer entityId : entityIdList) {
            programHierarchyDetails entityDetails = hierarchymanager.getProgramHierarchyItemDetails(entityId);

            /* Get the associated code sets for the passed in entity */
            List<Integer> activityCodes = activitycodemanager.getActivityCodesForEntity(entityId);

            if (activityCodes != null && !activityCodes.isEmpty()) {
                
                for (Integer activityCode : activityCodes) {
                    boolean codeSetFound = false;
                    
                    if(selectedContentCriteria != null) {
                        Iterator<surveyContentCriteria> it = selectedContentCriteria.iterator();
                        
                        while (it.hasNext()) {

                            surveyContentCriteria criteria = it.next();

                            if (Objects.equals(criteria.getSchoolId(), entityId) && Objects.equals(criteria.getCodeId(), activityCode)) {
                                codeSetFound = true;
                            }
                        }
                    }
                    
                    if (codeSetFound == false) {

                        activityCodes codeDetails = activitycodemanager.getActivityCodeById(activityCode);

                        surveyContentCriteria newCriteria = new surveyContentCriteria();
                        newCriteria.setCodeId(activityCode);
                        newCriteria.setCodeDesc(codeDetails.getCodeDesc());
                        newCriteria.setCodeValue(codeDetails.getCode());
                        newCriteria.setSchoolId(entityId);
                        newCriteria.setSchoolName(entityDetails.getName());

                        if (surveyId > 0) {
                            submittedsurveycontentcriteria codesetFound = surveyManager.getSurveyContentCriteria(surveyId, entityId, activityCode);

                            if (codesetFound != null && codesetFound.getId() > 0) {
                                newCriteria.setChecked(true);
                            }
                        }
                        
                        selectedContentCriteria.add(newCriteria);

                    }

                }
            }
        }

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/survey/contentCriteriaTable");

        /* Sort surveyContentCriterias */
        List<surveyContentCriteria> currentselectedContentCriteria = (List<surveyContentCriteria>)session.getAttribute("selectedContentCriterias");
        mav.addObject("contentCriteria", currentselectedContentCriteria);
        mav.addObject("disabled", disabled);

        return mav;

    }

    /**
     * The 'removeCodeSets' GET request will remove the selected code set from the entity.
     *
     * @param entityId
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/removeCodeSets", method = RequestMethod.GET)
    public @ResponseBody
    ModelAndView removeCodeSets(@RequestParam(value = "entityId", required = true) Integer entityId,
            @RequestParam(value = "disabled", required = true) Boolean disabled,
            HttpSession session) throws Exception {
        
        List<surveyContentCriteria> selectedContentCriteria = (List<surveyContentCriteria>)session.getAttribute("selectedContentCriterias");
        Iterator<surveyContentCriteria> it = selectedContentCriteria.iterator();

        List<surveyContentCriteria> toRemove = new ArrayList<surveyContentCriteria>();
        
        while (it.hasNext()) {

            surveyContentCriteria criteria = it.next();
            
            if (Objects.equals(criteria.getSchoolId(), entityId)) {
                toRemove.add(criteria);
            }
        }
        
        if (toRemove != null && !toRemove.isEmpty()) {
            selectedContentCriteria.removeAll(toRemove);
        }

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/survey/contentCriteriaTable");
        
        List<surveyContentCriteria> updatedselectedContentCriteria = (List<surveyContentCriteria>)session.getAttribute("selectedContentCriterias");
        mav.addObject("contentCriteria", updatedselectedContentCriteria);
        mav.addObject("disabled", disabled);

        return mav;

    }

    /**
     *
     * @param entityId
     * @param codeId
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/saveSelCodeSet", method = RequestMethod.POST)
    public @ResponseBody
    Integer saveSelCodeSet(@RequestParam(value = "entityId", required = true) Integer entityId, 
            @RequestParam(value = "codeId", required = true) Integer codeId,
            HttpSession session) throws Exception {

        List<surveyContentCriteria> selectedContentCriteria = (List<surveyContentCriteria>)session.getAttribute("selectedContentCriterias");
        Iterator<surveyContentCriteria> it = selectedContentCriteria.iterator();

        while (it.hasNext()) {

            surveyContentCriteria criteria = it.next();

            if (Objects.equals(criteria.getSchoolId(), entityId) && Objects.equals(criteria.getCodeId(), codeId)) {
                criteria.setChecked(true);
            }
        }

        return (Integer) 1;
    }

    /**
     *
     * @param entityId
     * @param codeId
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/removeSelCodeSet", method = RequestMethod.POST)
    public @ResponseBody
    Integer removeSelCodeSet(@RequestParam(value = "entityId", required = true) Integer entityId, 
            @RequestParam(value = "codeId", required = true) Integer codeId,
            HttpSession session) throws Exception {

        List<surveyContentCriteria> selectedContentCriteria = (List<surveyContentCriteria>)session.getAttribute("selectedContentCriterias");
        Iterator<surveyContentCriteria> it = selectedContentCriteria.iterator();

        while (it.hasNext()) {

            surveyContentCriteria criteria = it.next();

            if (Objects.equals(criteria.getSchoolId(), entityId) && Objects.equals(criteria.getCodeId(), codeId)) {
                criteria.setChecked(false);
            }
        }

        return (Integer) 1;
    }
    
    /**
     * The 'removeEntry' POST request will mark the survey submission as deleted.
     * 
     * @param surveyId
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/removeEntry", method = RequestMethod.POST)
    public @ResponseBody
    Integer removeEntry(@RequestParam(value = "i", required = true) Integer surveyId) throws Exception {

        /* Get the submitted surveys for the selected survey type */
        if (!"".equals(surveyId) && surveyId != null) {
           
            submittedSurveys survey = surveyManager.getSubmittedSurvey(surveyId);
            
            survey.setDeleted(true);
            
            surveyManager.deleteSurveyEntry(survey);
        }

        return (Integer) 1;
    }
    
    /**
     * The 'getSurveyDocuments' GET request will return a list of submitted survey documents.
     *
     * @param surveyId
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getSurveyDocuments.do", method = RequestMethod.GET)
    public @ResponseBody
    ModelAndView getSurveyDocuments(@RequestParam(value = "surveyId", required = true) Integer surveyId) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/survey/uploadedDocs");
        mav.addObject("surveyId", surveyId);
        
        /* Get a list of survey documents */
        List<submittedSurveyDocuments> surveyDocuments = surveyManager.getSubmittedSurveyDocuments(surveyId);
        
        if(surveyDocuments != null && surveyDocuments.size() > 0) {
            for(submittedSurveyDocuments document : surveyDocuments) {
                if(document.getUploadedFile() != null && !"".equals(document.getUploadedFile())) {
                    int index = document.getUploadedFile().lastIndexOf('.');
                    document.setFileExt(document.getUploadedFile().substring(index+1));
                    
                    if(document.getUploadedFile().length() > 60) {
                        String shortenedTitle = document.getUploadedFile().substring(0,30) + "..." + document.getUploadedFile().substring(document.getUploadedFile().length()-10, document.getUploadedFile().length());
                        document.setShortenedTitle(shortenedTitle);
                    }
                    document.setEncodedTitle(URLEncoder.encode(document.getUploadedFile(),"UTF-8"));
                }
            }
        }
        
        mav.addObject("surveyDocuments", surveyDocuments);

        return mav;

    }
    
    /**
     * The 'saveDocumentForm' POST request will handle saving the new/updated document
     * message.
     *
     * @param surveyDocuments
     * @param redirectAttr
     * @param session
     * @param surveyId
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/saveDocumentForm.do", method = RequestMethod.POST)
    public @ResponseBody
    ModelAndView saveDocumentForm(@RequestParam(value = "surveyDocuments", required = false) List<MultipartFile> surveyDocuments, RedirectAttributes redirectAttr,
            HttpSession session, @RequestParam(value = "surveyId", required = true) Integer surveyId,
            @RequestParam(value = "completed", required = true) Integer completed,
            @RequestParam(value = "selectedEntities", required = false) List<String> selectedEntities) throws Exception {

        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");

        if (surveyDocuments != null) {
            for(MultipartFile uploadedFile : surveyDocuments) {
                
                submittedSurveyDocuments surveyDocument = new submittedSurveyDocuments();
                surveyDocument.setSystemUserId(userDetails.getId());
                surveyDocument.setSubmittedSurveyId(surveyId);
                
                surveyManager.saveSurveyDocument(surveyDocument, uploadedFile, programId);
            }
        }
        
        if("1".equals(completed.toString())) {
            submittedSurveys submittedSurveyDetails = surveyManager.getSubmittedSurvey(surveyId);
            
            encryptObject encrypt = new encryptObject();
            Map<String, String> map;

            //Encrypt the use id to pass in the url
            map = new HashMap<String, String>();
            map.put("id", Integer.toString(submittedSurveyDetails.getSurveyId()));
            map.put("topSecret", topSecret);

            String[] encrypted = encrypt.encryptObject(map);
            
            surveys surveyDetails = surveyManager.getSurveyDetails(submittedSurveyDetails.getSurveyId());
            redirectAttr.addFlashAttribute("surveyDetails", surveyDetails);
            List<district> districtList = (List<district>)session.getAttribute("districtList");
            redirectAttr.addFlashAttribute("selDistricts", districtList);
            redirectAttr.addFlashAttribute("surveys", surveys);
            redirectAttr.addFlashAttribute("selectedEntities", selectedEntities.toString().replace("[", "").replace("]", ""));
            redirectAttr.addFlashAttribute("i", encrypted[0]);
            redirectAttr.addFlashAttribute("v", encrypted[1]);
            redirectAttr.addFlashAttribute("submittedSurveyId", surveyId);

            /* Get a list of survey documents */
            List<submittedSurveyDocuments> uploadedsurveyDocuments = surveyManager.getSubmittedSurveyDocuments(surveyId);

            if(uploadedsurveyDocuments != null && uploadedsurveyDocuments.size() > 0) {
                for(submittedSurveyDocuments document : uploadedsurveyDocuments) {
                    if(document.getUploadedFile() != null && !"".equals(document.getUploadedFile())) {
                        int index = document.getUploadedFile().lastIndexOf('.');
                        document.setFileExt(document.getUploadedFile().substring(index+1));
                        
                        if(document.getUploadedFile().length() > 60) {
                            String shortenedTitle = document.getUploadedFile().substring(0,30) + "..." + document.getUploadedFile().substring(document.getUploadedFile().length()-10, document.getUploadedFile().length());
                            document.setShortenedTitle(shortenedTitle);
                        }
                        document.setEncodedTitle(URLEncoder.encode(document.getUploadedFile(),"UTF-8"));
                        
                    }
                }
            }
            
            redirectAttr.addFlashAttribute("surveyDocuments", uploadedsurveyDocuments);
            
            ModelAndView mav = new ModelAndView(new RedirectView("/surveys/completedSurvey"));
            return mav;

        }
        else {
            redirectAttr.addFlashAttribute("message", "fileUploaded");
            ModelAndView mav = new ModelAndView(new RedirectView("/surveys"));
            return mav;
        }

    }
    
    /**
     * The 'deleteDocument' POST request will remove the clicked uploaded
     * document.
     *
     * @param documentId The id of the clicked document.
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/deleteDocument.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer deleteDocument(@RequestParam(value = "documentId", required = true) Integer documentId) throws Exception {
        
        submittedSurveyDocuments documentDetails = surveyManager.getDocumentById(documentId);
        documentDetails.setStatus(false);
        surveyManager.saveSurveyDocument(documentDetails, null, programId);
        return 1;
    }
    
    /**
     * 
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/completedSurvey", method = RequestMethod.GET)
    public ModelAndView completedSurvey() throws Exception {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/completedSurvey");
        
        return mav;
    }
}
