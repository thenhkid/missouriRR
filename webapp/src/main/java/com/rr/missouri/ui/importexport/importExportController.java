/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.importexport;

import com.registryKit.exportTool.export;
import com.registryKit.exportTool.exportManager;
import com.registryKit.exportTool.progressBar;
import com.registryKit.program.programManager;
import com.registryKit.reference.fileSystem;
import com.registryKit.survey.SurveyQuestions;
import com.registryKit.survey.submittedSurveys;
import com.registryKit.survey.surveyManager;
import com.registryKit.survey.surveys;
import com.registryKit.user.User;
import com.registryKit.user.userManager;
import com.registryKit.user.userProgramModules;
import com.rr.missouri.ui.security.encryptObject;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

/**
 *
 * @author chadmccue
 */
@Controller
@RequestMapping("/import-export")
public class importExportController {

    private static Integer moduleId = 4;

    @Autowired
    private userManager usermanager;

    @Autowired
    private surveyManager surveyManager;

    @Autowired
    private exportManager exportManager;

    @Autowired
    private programManager programManager;

    @Value("${programId}")
    private Integer programId;

    @Value("${topSecret}")
    private String topSecret;

    private static boolean allowImport = false;
    private static boolean allowExport = false;

    @RequestMapping(value = "", method = RequestMethod.GET)
    public ModelAndView importExport(HttpSession session, RedirectAttributes redirectAttr) throws Exception {

        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");

        /* Get user permissions */
        userProgramModules modulePermissions = usermanager.getUserModulePermissions(programId, userDetails.getId(), moduleId);

        if (userDetails.getRoleId() == 2) {
            allowImport = false; //Import is not a feature for this registry
            allowExport = true;
        } else {
            allowImport = false; //Import is not a feature for this registry
            allowExport = modulePermissions.isAllowExport();
        }

        if (allowImport == true) {
            ModelAndView mav = new ModelAndView(new RedirectView("/import-export/import"));
            return mav;
        } else if (allowExport == true) {
            ModelAndView mav = new ModelAndView(new RedirectView("/import-export/export"));
            return mav;
        } else {
            ModelAndView mav = new ModelAndView(new RedirectView("/import-export/export"));
            return mav;
        }

    }

    /**
     * The '/export' GET request will display the export page.
     *
     * @param session
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/export", method = RequestMethod.GET)
    public ModelAndView export(HttpSession session) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/export");
        mav.addObject("allowImport", allowImport);
        mav.addObject("allowExport", allowExport);

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

            survey.setTimesTaken(surveyManager.getSubmittedSurveys(survey.getId(), null, null).size());
        }

        mav.addObject("surveys", surveyList);

        return mav;

    }

    /**
     *
     * @param surveyId
     * @param session
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getExportModal.do", method = RequestMethod.GET)
    public ModelAndView getExportModal(@RequestParam(value = "surveyId", required = true) Integer surveyId, HttpSession session, HttpServletRequest request) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/importExport/exportModal");

        String surveyName = surveyManager.getSurveyDetails(surveyId).getTitle().replaceAll("[^A-Za-z0-9 ]", "").replace(" ", "");

        export exportDetails = new export();
        exportDetails.setSurveyId(surveyId);
        exportDetails.setExportName(surveyName);
        exportDetails.setQuestionOnly(false);

        Random rand = new Random();
        exportDetails.setUniqueId(rand.nextInt(50000000));

        mav.addObject("exportDetails", exportDetails);
        mav.addObject("showDateRange", true);

        return mav;
    }

    /**
     *
     * @param surveyId
     * @param session
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/saveActivityLogExport.do", method = RequestMethod.POST)
    public ModelAndView saveExport(@ModelAttribute(value = "exportDetails") export exportDetails, BindingResult errors, HttpSession session, HttpServletRequest request) throws Exception {

        if (errors.hasErrors()) {
            for (ObjectError error : errors.getAllErrors()) {
                System.out.println(error.getDefaultMessage());
            }
        }

        Date realStartDate = null;
        Date realEndDate = null;

        if (exportDetails.getQuestionOnly() == false) {
            /* Need to transfer String start and end date to real date */
            DateFormat format = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
            realStartDate = format.parse(exportDetails.getStartDate() + " 00:00:00");
            realEndDate = format.parse(exportDetails.getEndDate() + " 23:59:59");

            exportDetails.setExportStartDate(realStartDate);
            exportDetails.setExportEndDate(realEndDate);
        }

        progressBar newProgressBar = new progressBar();
        newProgressBar.setExportId(exportDetails.getUniqueId());
        newProgressBar.setPercentComplete(0);

        exportManager.saveProgessBar(newProgressBar);

        //String exportFileName = exportManager.createSurveyExport(exportDetails, programId);
        String exportFileName = "";

        String registryName = programManager.getProgramById(programId).getProgramName().replaceAll(" ", "-").toLowerCase();

        /* Get a list of survey questions */
        List<SurveyQuestions> surveyQuestions = surveyManager.getSurveyQuestionList(exportDetails.getSurveyId());

        List<submittedSurveys> submittedSurveys = null;
        boolean createExport = true;

        /* Get a list of submitted surveys */
        if (exportDetails.getQuestionOnly() == false) {
            //submittedSurveys = surveyManager.getSubmittedSurveys(exportDetails.getSurveyId(), exportDetails.getExportStartDate(), exportDetails.getExportEndDate());
            
        	submittedSurveys = surveyManager.getSubmittedSurveysByQuestionDate(exportDetails.getSurveyId(), surveyManager.getSurveyDateQuestionId(exportDetails.getSurveyId()), exportDetails.getExportStartDate(), exportDetails.getExportEndDate());
            
            if (submittedSurveys == null || submittedSurveys.isEmpty()) {
                createExport = false;
            }
        }

        if (surveyQuestions != null && surveyQuestions.size() > 0 && createExport == true) {
            DateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmssS");
            Date date = new Date();
            String fileName = "";
            String delimiter = ",";

            if (exportDetails.getExportType() == 1) {
                fileName = new StringBuilder().append(exportDetails.getExportName()).append(dateFormat.format(date)).append(".csv").toString();
                delimiter = ",";
            } else if (exportDetails.getExportType() == 2) {
                fileName = new StringBuilder().append(exportDetails.getExportName()).append(dateFormat.format(date)).append(".txt").toString();
                delimiter = ",";
            } else if (exportDetails.getExportType() == 3) {
                fileName = new StringBuilder().append(exportDetails.getExportName()).append(dateFormat.format(date)).append(".txt").toString();
                delimiter = "|";
            } else if (exportDetails.getExportType() == 4) {
                fileName = new StringBuilder().append(exportDetails.getExportName()).append(dateFormat.format(date)).append(".txt").toString();
                delimiter = "\t";
            }

            /* Create new export file */
            InputStream inputStream = null;
            OutputStream outputStream = null;

            fileSystem dir = new fileSystem();
            dir.setDir(registryName, "exportFiles");

            File newFile = new File(dir.getDir() + fileName);

            /* Create the empty file in the correct location */
            try {

                if (newFile.exists()) {
                    int i = 1;
                    while (newFile.exists()) {
                        int iDot = fileName.lastIndexOf(".");
                        newFile = new File(dir.getDir() + fileName.substring(0, iDot) + "_(" + ++i + ")" + fileName.substring(iDot));
                    }
                    fileName = newFile.getName();
                    newFile.createNewFile();
                } else {
                    newFile.createNewFile();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }

            /* Read in the file */
            FileInputStream fileInput = null;
            File file = new File(dir.getDir() + fileName);
            fileInput = new FileInputStream(file);

            exportFileName = fileName;

            FileWriter fw = null;

            try {
                fw = new FileWriter(file, true);
            } catch (IOException ex) {
                Logger.getLogger(exportManager.class.getName()).log(Level.SEVERE, null, ex);
            }

            StringBuilder exportRow = new StringBuilder();

            /* Set the header row */
            if (exportDetails.getQuestionOnly() == false) {
                exportRow.append("Entry Id").append(delimiter);
                exportRow.append("Date Submitted").append(delimiter);
                exportRow.append("Tier 1").append(delimiter);
                exportRow.append("Tier 2").append(delimiter);
                exportRow.append("Tier 3").append(delimiter);
                exportRow.append("Selected Content/Criteria").append(delimiter);

                for (SurveyQuestions question : surveyQuestions) {
                    exportRow.append('"').append(question.getQuestion().replace("\"", "\"\"")).append('"').append(delimiter);
                }
            } else {
                for (SurveyQuestions question : surveyQuestions) {
                    exportRow.append("q" + question.getId()).append(delimiter);
                }
            }

            exportRow.append(System.getProperty("line.separator"));

            fw.write(exportRow.toString());

            String answerVal;

            Integer totalDone = 0;
            float percentComplete;

            progressBar exportProgressBar = exportManager.getProgressBar(exportDetails.getUniqueId());

            if (exportDetails.getQuestionOnly() == true) {
                exportRow = new StringBuilder();

                for (SurveyQuestions question : surveyQuestions) {
                    exportRow.append(question.getQuestion()).append(delimiter);

                    //Update progress bar
                    totalDone = totalDone + 1;
                    percentComplete = ((float) totalDone) / surveyQuestions.size();

                    exportProgressBar.setPercentComplete(Math.round(percentComplete * 100));

                    exportManager.saveProgessBar(exportProgressBar);
                }

                fw.write(exportRow.toString());
            } else {

                for (submittedSurveys submission : submittedSurveys) {

                    exportRow = new StringBuilder();

                    exportRow.append(submission.getId()).append(delimiter).append(submission.getDateCreated()).append(delimiter);

                    List selectedTierOneandTwo = surveyManager.getSubmittedSurveyTiersOneandTwo(submission.getId());

                    if (selectedTierOneandTwo != null) {
                        for (ListIterator iter = selectedTierOneandTwo.listIterator(); iter.hasNext();) {

                            Object[] row = (Object[]) iter.next();

                            String selectedTierOnes = String.valueOf(row[0]);
                            String selectedTierTwos = String.valueOf(row[1]);

                            /* Selected Tier 1 */
                            if (!"".equals(selectedTierOnes)) {
                                exportRow.append('"').append(selectedTierOnes.replace("\"", "\"\"")).append('"').append(delimiter);
                            } else {
                                exportRow.append("").append(delimiter);
                            }

                            /* Selected Tier 2 */
                            if (!"".equals(selectedTierTwos)) {
                                exportRow.append('"').append(selectedTierTwos.replace("\"", "\"\"")).append('"').append(delimiter);
                            } else {
                                exportRow.append("").append(delimiter);
                            }
                        }
                    } else {
                        exportRow.append("").append(delimiter).append("").append(delimiter);
                    }

                    List selectedContentandEntities = surveyManager.getSubmittedSurveyContentCriteriaForReport(submission.getId());

                    if (selectedContentandEntities != null) {
                        for (ListIterator iter = selectedContentandEntities.listIterator(); iter.hasNext();) {

                            Object[] row = (Object[]) iter.next();

                            String selectedContent = String.valueOf(row[0]);
                            String selectedEntities = String.valueOf(row[1]);

                            if (!"".equals(selectedEntities)) {
                                exportRow.append('"').append(selectedEntities.replace("\"", "\"\"")).append('"').append(delimiter);
                            } else {
                                exportRow.append("").append(delimiter);
                            }

                            if (!"".equals(selectedContent)) {
                                exportRow.append('"').append(selectedContent.replace("\"", "\"\"")).append('"').append(delimiter);
                            } else {
                                exportRow.append("").append(delimiter);
                            }
                        }
                    } else {
                        exportRow.append("").append(delimiter).append("").append(delimiter);
                    }

                    List answerValues = surveyManager.getSubmittedSurveyQuestionAnswerForReport(submission.getId(), surveyQuestions);

                    Iterator<String> answers = answerValues.iterator();

                    while (answers.hasNext()) {
                        String answer = answers.next();

                        if (answer == null) {
                            answer = "";
                        }
                        exportRow.append('"').append(answer.replace("\"", "\"\"")).append('"').append(delimiter);

                    }

                    /*for(SurveyQuestions question : surveyQuestions) {

                        answerVal = surveyManager.getSubmittedSurveyQuestionAnswer(submission.getId(), question.getId());

                        exportRow.append('"').append(answerVal.replace("\"", "\"\"")).append('"').append(delimiter);

                    }*/
                    exportRow.append(System.getProperty("line.separator"));

                    fw.write(exportRow.toString());

                    //Update progress bar
                    totalDone = totalDone + 1;
                    percentComplete = ((float) totalDone) / submittedSurveys.size();

                    exportProgressBar.setPercentComplete(Math.round(percentComplete * 100));

                    exportManager.saveProgessBar(exportProgressBar);

                }
            }

            fw.close();
        }

        ModelAndView mav = new ModelAndView();

        /* If no results are found */
        if (exportFileName.isEmpty()) {
            mav.setViewName("/importExport/exportModal");

            String surveyName = surveyManager.getSurveyDetails(exportDetails.getSurveyId()).getTitle().replaceAll("[^A-Za-z0-9 ]", "").replace(" ", "");

            export newexportDetails = new export();
            newexportDetails.setSurveyId(exportDetails.getSurveyId());
            newexportDetails.setExportName(surveyName);
            if (exportDetails.getQuestionOnly() == false) {
                newexportDetails.setExportStartDate(realStartDate);
                newexportDetails.setExportEndDate(realEndDate);
            }

            mav.addObject("exportDetails", exportDetails);
            mav.addObject("noresults", true);
            mav.addObject("showDateRange", true);
        } else {
            mav.setViewName("/importExport/exportDownloadModal");
            mav.addObject("exportFileName", exportFileName);
        }

        return mav;
    }

    /**
     * The 'getExportQuestionModal.do' GET request will show the survey question export modal.
     *
     * @param surveyId
     * @param session
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getExportQuestionModal.do", method = RequestMethod.GET)
    public ModelAndView getExportQuestionModal(@RequestParam(value = "surveyId", required = true) Integer surveyId, HttpSession session, HttpServletRequest request) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/importExport/exportModal");

        String surveyName = surveyManager.getSurveyDetails(surveyId).getTitle().replaceAll("[^A-Za-z0-9 ]", "").concat("_questions").replace(" ", "");

        export exportDetails = new export();
        exportDetails.setSurveyId(surveyId);
        exportDetails.setExportName(surveyName);
        exportDetails.setQuestionOnly(true);

        Random rand = new Random();
        exportDetails.setUniqueId(rand.nextInt(50000000));

        mav.addObject("exportDetails", exportDetails);
        mav.addObject("showDateRange", false);

        return mav;
    }
    
    /**
     * The '/updateProgressBar.do' request will return the current value of export progress bar.
     *
     * @param uniqueId The unique export id
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/updateProgressBar.do", method = RequestMethod.GET)
    @ResponseBody
    public Integer updateProgressBar(HttpSession session, @RequestParam(value = "uniqueId", required = false) Integer uniqueId) throws Exception {

        if (uniqueId != null && !"".equals(uniqueId) && uniqueId > 0) {
            progressBar exportProgressBar = exportManager.getProgressBar(uniqueId);

            if (exportProgressBar != null) {
                return exportProgressBar.getPercentComplete();
            } else {
                return 0;
            }
        }
        else {
           return 0;
        }
    }
}
