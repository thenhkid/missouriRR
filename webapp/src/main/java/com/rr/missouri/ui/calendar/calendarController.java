/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.calendar;

import com.registryKit.calendar.calendarEventDocuments;
import com.registryKit.calendar.calendarEventEntities;
import com.registryKit.calendar.calendarEventNotifications;
import com.registryKit.calendar.calendarEventTypeColors;
import com.registryKit.calendar.calendarEventTypes;
import com.registryKit.calendar.calendarEvents;
import com.registryKit.calendar.calendarManager;
import com.registryKit.calendar.calendarNotificationPreferences;
import com.registryKit.hierarchy.hierarchyManager;
import com.registryKit.hierarchy.programHierarchyDetails;
import com.registryKit.hierarchy.programOrgHierarchy;
import com.registryKit.messenger.emailManager;
import com.registryKit.messenger.emailMessage;
import com.registryKit.program.program;
import com.registryKit.program.programManager;
import com.registryKit.user.User;
import com.registryKit.user.userManager;
import com.registryKit.user.userProgramModules;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

/**
 *
 * @author chadmccue
 */
@Controller
@RequestMapping("/calendar")
public class calendarController {

    private static final Integer moduleId = 7;

    @Autowired
    calendarManager calendarManager;

    @Autowired
    private userManager usermanager;

    @Autowired
    private programManager programManager;
    
    @Autowired
    private hierarchyManager hierarchymanager;

    @Autowired
    private emailManager emailManager;

    @Value("${programId}")
    private Integer programId;

    @Value("${topSecret}")
    private String topSecret;

    private static boolean allowCreate = false;
    private static boolean allowEdit = false;

    @RequestMapping(value = "", method = RequestMethod.GET)
    public ModelAndView calendarHome(HttpSession session) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/calendar");

        List<calendarEventTypes> eventTypes = calendarManager.getEventCategories(programId);

        mav.addObject("eventTypes", eventTypes);

        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");

        /* Get user permissions */
        userProgramModules modulePermissions = usermanager.getUserModulePermissions(programId, userDetails.getId(), moduleId);

        if (userDetails.getRoleId() == 2) {
            allowCreate = true;
        } else {
            allowCreate = modulePermissions.isAllowCreate();
        }

        mav.addObject("allowCreate", allowCreate);

        return mav;
    }

    /**
     * The 'searchEvents' POST request will search the events table for logged
     * events.
     *
     * @param session
     * @param searchTerm The term to match events to.
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "searchEvents.do", method = RequestMethod.GET)
    public @ResponseBody
    ModelAndView searchEvents(HttpSession session, @RequestParam(value = "searchTerm", required = true) String searchTerm) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/calendar/searchResults");

        User userDetails = (User) session.getAttribute("userDetails");

        List<calendarEvents> events = calendarManager.searchEvents(userDetails, programId, searchTerm);

        if (events != null && events.size() > 0) {
            for (calendarEvents event : events) {
                calendarEventTypes eventTypeObject = calendarManager.getEventType(event.getEventTypeId());

                event.setEventColor(eventTypeObject.getEventTypeColor());
            }
        }

        mav.addObject("foundEvents", events);

        return mav;

    }

    @RequestMapping(value = "/saveEventType.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer saveEventType(HttpSession session, HttpServletRequest request) throws Exception {

        calendarEventTypes eventTypeObject = null;

        String eventTypeId = request.getParameter("eventTypeId");
        String eventType = request.getParameter("eventType");
        String eventTypeColor = request.getParameter("eventTypeColor");
        String adminOnly = request.getParameter("adminOnly");
        boolean isAdminOnly = false;

        if ("true".equals(adminOnly)) {
            isAdminOnly = true;
        }

        if (Integer.parseInt(eventTypeId) == 0) {
            eventTypeObject = new calendarEventTypes();
            eventTypeObject.setProgramId(programId);
            eventTypeObject.setEventType(eventType);
            eventTypeObject.setEventTypeColor(eventTypeColor);
            eventTypeObject.setAdminOnly(isAdminOnly);
        } else {
            eventTypeObject = calendarManager.getEventType(Integer.parseInt(eventTypeId));
            eventTypeObject.setProgramId(programId);
            eventTypeObject.setEventType(eventType);
            eventTypeObject.setEventTypeColor(eventTypeColor);
            eventTypeObject.setAdminOnly(isAdminOnly);
        }

        calendarManager.saveEventType(eventTypeObject);

        return 1;

    }

    @RequestMapping(value = "/getEventType.do", method = RequestMethod.GET)
    public @ResponseBody
    JSONArray getEventType(HttpSession session, HttpServletRequest request) throws Exception {

        String eventTypeId = request.getParameter("eventTypeId");
        JSONArray array = new JSONArray();

        calendarEventTypes eventTypeObject = calendarManager.getEventType(Integer.parseInt(eventTypeId));

        array.add(eventTypeObject.getId());
        array.add(eventTypeObject.getProgramId());
        array.add(eventTypeObject.getEventType());
        array.add(eventTypeObject.getEventTypeColor());
        array.add(eventTypeObject.getAdminOnly());

        return array;

    }

    @RequestMapping(value = "/getEventsJSON.do", method = RequestMethod.GET)
    public @ResponseBody
    JSONArray getEventsJSON(HttpSession session, HttpServletRequest request) throws Exception {

        JSONObject data = new JSONObject();

        User userDetails = (User) session.getAttribute("userDetails");

        String from = request.getParameter("start");
        String to = request.getParameter("end");
        String eventTypeId = request.getParameter("eventTypeId");

        JSONArray eventsJSON = calendarManager.getEventsJSON(userDetails, programId, from, to, eventTypeId);

        data.put("success", 1);
        data.put("result", eventsJSON);

        return eventsJSON;

    }

    @RequestMapping(value = "/saveEvent.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer saveEvent(@ModelAttribute(value = "calendarEvent") calendarEvents calendarEvent, BindingResult errors, @RequestParam(value = "alertAllUsers", required = false, defaultValue = "0") Integer alertUsers,
            @RequestParam(value = "eventDocuments", required = false) List<MultipartFile> eventDocuments,
            HttpSession session, HttpServletRequest request,
            @RequestParam(value = "selectedEntities", required = false) List<Integer> selectedEntities) throws Exception {

        if (errors.hasErrors()) {
            for (ObjectError error : errors.getAllErrors()) {
                System.out.println(error.getDefaultMessage());
            }
        }

        User userDetails = (User) session.getAttribute("userDetails");

        boolean alertAllUsers = false;
        
        if (alertUsers == 1) {
            alertAllUsers = true;
        }

        /* Need to transfer String start and end date to real date */
        DateFormat format = new SimpleDateFormat("MM/dd/yyyy");
        Date realStartDate = format.parse(calendarEvent.getStartDate());
        Date realEndDate = format.parse(calendarEvent.getEndDate());

        calendarEvent.setEventStartDate(realStartDate);
        calendarEvent.setEventEndDate(realEndDate);

        if (eventDocuments != null) {
            calendarEvent.setUploadedDocuments(eventDocuments);
        }

        Integer eventId = calendarManager.saveEvent(calendarEvent);

        program programDetails = programManager.getProgramById(programId);

        calendarEventTypes eventType = calendarManager.getEventType(calendarEvent.getEventTypeId());
        
        /* Remove existing entities */
        calendarManager.removeEventEntities(programId, eventId);
        
        /* Enter the selected counties */
        if (calendarEvent.getWhichEntity() == 1) {
            /* Need to get all top entities for the program */
            programOrgHierarchy topLevel = hierarchymanager.getProgramOrgHierarchyBydspPos(1, programId);
            List<programHierarchyDetails> entities = hierarchymanager.getProgramHierarchyItems(topLevel.getId(), 0);

            if (entities != null && entities.size() > 0) {
                for (programHierarchyDetails entity : entities) {
                    calendarEventEntities eventEntity = new calendarEventEntities();
                    eventEntity.setEntityId(entity.getId());
                    eventEntity.setProgramId(programId);
                    eventEntity.setEventId(eventId);
                    
                    calendarManager.saveEventEntities(eventEntity);
                }
            }
        } else if (calendarEvent.getWhichEntity() == 2 && selectedEntities != null && !"".equals(selectedEntities)) {
            for (Integer entity : selectedEntities) {
                calendarEventEntities eventEntity = new calendarEventEntities();
                eventEntity.setEntityId(entity);
                eventEntity.setProgramId(programId);
                eventEntity.setEventId(eventId);
                
                calendarManager.saveEventEntities(eventEntity);
            }
        }
        
        //Modifed Event Notification
        if (calendarEvent.getId() > 0 && alertAllUsers == true) {
            
            /* Get a list of users who want to be notified of event changes */
            List<calendarNotificationPreferences> notifyUserList = calendarManager.getModifiedEventUserNotifications(programId, eventId);
            
            if (notifyUserList != null && notifyUserList.size() > 0) {
                
                for (calendarNotificationPreferences notification : notifyUserList) {
                    StringBuilder sb = new StringBuilder();

                    User userdetails = usermanager.getUserById(notification.getSystemUserId());
                    
                    if (calendarEvent.getSystemUserId() != userdetails.getId() && (eventType.getAdminOnly() == false || (eventType.getAdminOnly() == true && userdetails.getRoleId() == 2))) {
                        emailMessage messageDetails = new emailMessage();

                        messageDetails.settoEmailAddress(notification.getNotificationEmail());
                        messageDetails.setfromEmailAddress(programDetails.getEmailAddress());
                        messageDetails.setmessageSubject(programDetails.getProgramName() + " Calendar Event Modification");
                        
                        sb.append("Below are the new details for the <strong>").append(calendarEvent.getEventTitle()).append("</strong> event.");
                        sb.append("<br /><br />");
                        sb.append("<strong>Start Date/Time: </strong>").append(calendarEvent.getEventStartDate().toString().substring(0, 10)).append(" ").append(calendarEvent.getEventStartTime());
                        sb.append("<br /><br />");
                        sb.append("<strong>End Date/Time: </strong>").append(calendarEvent.getEventEndDate().toString().substring(0, 10)).append(" ").append(calendarEvent.getEventEndTime());
                        if (!"".equals(calendarEvent.getEventLocation())) {
                            sb.append("<br /><br />").append("<strong>Where: </strong>").append(calendarEvent.getEventLocation());
                        }
                        if (!"".equals(calendarEvent.getEventNotes())) {
                            sb.append("<br /><br />").append("<strong>Notes: </strong>").append("<br />").append(calendarEvent.getEventNotes());
                        }

                        messageDetails.setmessageBody(sb.toString());

                        emailManager.sendEmail(messageDetails);
                    }

                }
            }

        } //New Event Notification
        else if (alertAllUsers == true) {

            /* Get a list of users who want to be notified of event changes */
            List<calendarNotificationPreferences> notifyUserList = calendarManager.getNewEventUserNotifications(programId, eventId);

            if (notifyUserList != null && notifyUserList.size() > 0) {

                for (calendarNotificationPreferences notification : notifyUserList) {
                    StringBuilder sb = new StringBuilder();

                    User userdetails = usermanager.getUserById(notification.getSystemUserId());

                    if (calendarEvent.getSystemUserId() != userdetails.getId() && (eventType.getAdminOnly() == false || (eventType.getAdminOnly() == true && userdetails.getRoleId() == 2))) {
                        emailMessage messageDetails = new emailMessage();

                        messageDetails.settoEmailAddress(notification.getNotificationEmail());
                        messageDetails.setfromEmailAddress(programDetails.getEmailAddress());
                        messageDetails.setmessageSubject(programDetails.getProgramName() + " New Calendar Event");
                        
                        sb.append("<strong>").append(calendarEvent.getEventTitle()).append("</strong>");
                        sb.append("<br /><br />");
                        sb.append("<strong>Start Date/Time: </strong>").append(calendarEvent.getEventStartDate().toString().substring(0, 10)).append(" ").append(calendarEvent.getEventStartTime());
                        sb.append("<br /><br />");
                        sb.append("<strong>End Date/Time: </strong>").append(calendarEvent.getEventEndDate().toString().substring(0, 10)).append(" ").append(calendarEvent.getEventEndTime());
                        if (!"".equals(calendarEvent.getEventLocation())) {
                            sb.append("<br /><br />").append("<strong>Where: </strong>").append(calendarEvent.getEventLocation());
                        }
                        if (!"".equals(calendarEvent.getEventNotes())) {
                            sb.append("<br /><br />").append("<strong>Notes: </strong>").append("<br />").append(calendarEvent.getEventNotes());
                        }

                        messageDetails.setmessageBody(sb.toString());

                        emailManager.sendEmail(messageDetails);
                    }
                }

            }

        }

        return 1;

    }

    /**
     *
     * @param session
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getEventDetails.do", method = RequestMethod.GET)
    public ModelAndView getEventDetails(HttpSession session, HttpServletRequest request) throws Exception {

        Integer eventId = Integer.parseInt(request.getParameter("eventId"));

        calendarEvents eventDetails = calendarManager.getEventDetails(eventId);

        calendarEventTypes eventTypeObject = calendarManager.getEventType(eventDetails.getEventTypeId());

        eventDetails.setEventColor(eventTypeObject.getEventTypeColor());
        eventDetails.setEventType(eventTypeObject.getEventType());

        /* See if there are any existing documents */
        List<calendarEventDocuments> existingDocuments = calendarManager.getEventDocuments(eventDetails.getId());

        if (existingDocuments != null) {
            eventDetails.setExistingDocuments(existingDocuments);
        }

        ModelAndView mav = new ModelAndView();

        User userDetails = (User) session.getAttribute("userDetails");

        if (eventDetails.getSystemUserId() == userDetails.getId() || userDetails.getRoleId() == 2) {
            mav.setViewName("/calendar/newEventModal");

            //List<calendarEventTypes> eventTypes = calendarManager.getEventTypeColors(0);
            List<calendarEventTypes> eventTypes = calendarManager.getEventCategories(programId);
            mav.addObject("eventTypes", eventTypes);

            List<calendarEventTypes> selectedEventTypes = calendarManager.getEventTypeColors(eventId);

            for (calendarEventTypes selectedEventType : selectedEventTypes) {
                if ("selected".equals(selectedEventType.getSelectedColor())) {
                    mav.addObject("selectedEventTypeColor", selectedEventType.getEventTypeColor());
                }
            }
            
             /* Get the event notification for the user */
            calendarEventNotifications eventNotification = calendarManager.getEventNotification(eventDetails.getId(), userDetails.getId());

            if (eventNotification != null) {
                eventDetails.setSendAlert(true);
                eventDetails.setEmailAlertMin(eventNotification.getEmailAlertMin());
            }
            
            List<calendarEventEntities> entities = calendarManager.getEventEntities(programId, eventDetails.getId());
            
            if(entities != null && entities.size() > 0) {
                List<Integer> entityList = new ArrayList<Integer>();
                for(calendarEventEntities entity : entities) {
                    entityList.add(entity.getEntityId());
                }
                eventDetails.setEventEntities(entityList);
            }
            
            programOrgHierarchy topLevel = hierarchymanager.getProgramOrgHierarchyBydspPos(1, programId);

            /* Get a list of top level entities */
            Integer userId = 0;
            if (userDetails.getRoleId() == 3) {
                userId = userDetails.getId();
            }
            List<programHierarchyDetails> counties = hierarchymanager.getProgramHierarchyItems(topLevel.getId(), 0);

            mav.addObject("countyList", counties);
            mav.addObject("topLevelName", topLevel.getName());

        } else {

            /* Get the event notification for the user */
            calendarEventNotifications eventNotification = calendarManager.getEventNotification(eventDetails.getId(), userDetails.getId());

            if (eventNotification != null) {
                eventDetails.setSendAlert(true);
                eventDetails.setEmailAlertMin(eventNotification.getEmailAlertMin());
            }

            mav.setViewName("/calendar/eventDetailsModal");
            mav.addObject("selectedEventTypeColor", "");
        }

        mav.addObject("calendarEvent", eventDetails);

        return mav;
    }

    /**
     * The 'saveEventNotification' POST request will save the notification alert
     * for the selected event and logged in user.
     *
     * @param session
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/saveEventNotification.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer saveEventNotification(HttpSession session, HttpServletRequest request) throws Exception {
        String eventId = request.getParameter("eventId");
        String alertMin = request.getParameter("alertMin");

        User userDetails = (User) session.getAttribute("userDetails");

        calendarEventNotifications eventNotification = new calendarEventNotifications();
        eventNotification.setEmailAlertMin(Integer.parseInt(alertMin));
        eventNotification.setSystemUserId(userDetails.getId());
        eventNotification.setEventId(Integer.parseInt(eventId));

        calendarManager.saveEventNotification(eventNotification);
        return 1;
    }

    /**
     *
     * @param session
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/deleteEventNotification.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer deleteEventNotification(HttpSession session, HttpServletRequest request) throws Exception {

        String eventId = request.getParameter("eventId");

        User userDetails = (User) session.getAttribute("userDetails");

        calendarManager.deleteEventNotification(Integer.parseInt(eventId), userDetails.getId());

        return 1;
    }

    /**
     *
     * @param session
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/deleteEvent.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer deleteEvent(HttpSession session, HttpServletRequest request) throws Exception {

        String eventId = request.getParameter("eventId");

        calendarManager.deleteEvent(Integer.parseInt(eventId));

        return 1;
    }

    /**
     * The 'deleteEventDocument' POST request will remove the clicked uploaded
     * document.
     *
     * @param documentId The id of the clicked document.
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/deleteEventDocument.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer deleteEventDocument(@RequestParam(value = "documentId", required = true) Integer documentId) throws Exception {

        calendarManager.deleteEventDocument(documentId);

        return 1;
    }

    /**
     *
     * @param session
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getNewEventForm.do", method = RequestMethod.GET)
    public ModelAndView getNewEventForm(HttpSession session, HttpServletRequest request) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/calendar/newEventModal");

        //List<calendarEventTypes> eventTypes = calendarManager.getEventTypeColors(0);
        List<calendarEventTypes> eventTypes = calendarManager.getEventCategories(programId);

        mav.addObject("eventTypes", eventTypes);

        User userDetails = (User) session.getAttribute("userDetails");

        /* Create an empty calender event */
        calendarEvents newCalendarEvent = new calendarEvents();
        newCalendarEvent.setProgramId(programId);
        newCalendarEvent.setSystemUserId(userDetails.getId());

        /* Set the event type by default to the first one in the system */
        newCalendarEvent.setEventTypeId(eventTypes.get(0).getId());
        mav.addObject("calendarEvent", newCalendarEvent);
        
        programOrgHierarchy topLevel = hierarchymanager.getProgramOrgHierarchyBydspPos(1, programId);

        /* Get a list of top level entities */
        Integer userId = 0;
        if (userDetails.getRoleId() == 3) {
            userId = userDetails.getId();
        }
        List<programHierarchyDetails> counties = hierarchymanager.getProgramHierarchyItems(topLevel.getId(), 0);

        mav.addObject("countyList", counties);
        mav.addObject("topLevelName", topLevel.getName());

        return mav;
    }

    /**
     *
     * @param session
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getEventTypes.do", method = RequestMethod.GET)
    public ModelAndView getEventTypes(HttpSession session, HttpServletRequest request) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/calendar/eventTypes");

        List<calendarEventTypes> eventTypes = calendarManager.getCalendarEventTypes(programId);
        mav.addObject("eventTypes", eventTypes);

        List<calendarEventTypeColors> eventTypeColors = calendarManager.getAllEventTypeColors();

        mav.addObject("colors", eventTypeColors);

        return mav;
    }

    @RequestMapping(value = "/isColorAvailable.do", method = RequestMethod.GET)
    public @ResponseBody
    Integer isColorAvailable(HttpSession session, @RequestParam(value = "hexColor", required = true) String hexColor, @RequestParam(value = "eventId", required = true) Integer eventId) throws Exception {
        Integer isAvailable = 0;

        boolean isAvailableBool = calendarManager.isColorAvailable(programId, hexColor, eventId);

        if (isAvailableBool) {
            isAvailable = 1;
        } else {
            isAvailable = 0;
        }

        return isAvailable;
    }

    @RequestMapping(value = "/getEventTypeId.do", method = RequestMethod.GET)
    public @ResponseBody
    Integer getEventTypeId(HttpSession session, HttpServletRequest request) throws Exception {

        String eventColor = request.getParameter("eventColor");

        return calendarManager.getEventTypeId(eventColor);

    }

    @RequestMapping(value = "/getEditEventForm.do", method = RequestMethod.GET)
    public ModelAndView getEditEventForm(HttpSession session, HttpServletRequest request) throws Exception {

        String eventId = request.getParameter("eventId");

        calendarEvents eventObject = calendarManager.getEventDetails(Integer.parseInt(eventId));

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/calendar/newEventModal");

        List<calendarEventTypes> eventTypes = calendarManager.getEventTypeColors(Integer.parseInt(eventId));

        mav.addObject("event", eventObject);
        mav.addObject("eventTypes", eventTypes);

        return mav;
    }

    @RequestMapping(value = "/getEventCategories.do", method = RequestMethod.GET)
    public ModelAndView getEventCategories(HttpSession session, HttpServletRequest request) throws Exception {

        String eventId = request.getParameter("eventId");

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/calendar/eventCategories");

        List<calendarEventTypes> eventTypes = calendarManager.getEventCategories(programId);

        mav.addObject("eventTypes", eventTypes);

        return mav;
    }

    /**
     * The 'getEventTypesColumn' GET request will return the html for the event
     * types column on the calendar homepage.
     *
     * @param session
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "getEventTypesColumn.do", method = RequestMethod.GET)
    public @ResponseBody
    ModelAndView getEventTypesColumn(HttpSession session) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/calendar/eventTypesColumn");

        List<calendarEventTypes> eventTypes = calendarManager.getEventCategories(programId);

        mav.addObject("eventTypes", eventTypes);

        return mav;

    }

    @RequestMapping(value = "/getEventNotificationModel.do", method = RequestMethod.GET)
    public ModelAndView getEventNotificationModel(HttpSession session, HttpServletRequest request) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/calendar/eventNotificationPreferences");

        User userDetails = (User) session.getAttribute("userDetails");

        calendarNotificationPreferences notificationPreferences = calendarManager.getNotificationPreferences(userDetails.getId());

        if (notificationPreferences != null) {
            mav.addObject("notificationPreferences", notificationPreferences);
        } else {
            calendarNotificationPreferences newNotificationPreferences = new calendarNotificationPreferences();
            newNotificationPreferences.setNewEventNotifications(false);
            newNotificationPreferences.setModifyEventNotifications(false);
            newNotificationPreferences.setNotificationEmail(userDetails.getEmail());
            newNotificationPreferences.setProgramId(programId);
            mav.addObject("notificationPreferences", newNotificationPreferences);
        }

        return mav;
    }

    @RequestMapping(value = "/saveNotificationPreferences.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer saveNotificationPreferences(@ModelAttribute(value = "notificationPreferences") calendarNotificationPreferences notificationPreferences, BindingResult errors,
            HttpSession session, HttpServletRequest request) throws Exception {

        User userDetails = (User) session.getAttribute("userDetails");

        notificationPreferences.setSystemUserId(userDetails.getId());

        calendarManager.saveNotificationPreferences(notificationPreferences);

        return 1;

    }
}
