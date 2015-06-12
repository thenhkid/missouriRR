/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.calendar;

import com.registryKit.calendar.calendarEventDocuments;
import com.registryKit.calendar.calendarEventTypeColors;
import com.registryKit.calendar.calendarEventTypes;
import com.registryKit.calendar.calendarEvents;
import com.registryKit.calendar.calendarManager;
import com.registryKit.user.User;
import com.registryKit.user.userManager;
import com.registryKit.user.userProgramModules;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
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
    
    private static Integer moduleId = 7;

    @Autowired
    calendarManager calendarManager;
    
    @Autowired
    private userManager usermanager;

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
        
        
        if(userDetails.getRoleId() == 2) {
            allowCreate = true;
        }
        else {
            allowCreate = modulePermissions.isAllowCreate();
        }
         
        mav.addObject("allowCreate", allowCreate);

        return mav;
    }
    
    /**
     * The 'searchEvents' POST request will search the events table for logged events.
     * 
     * @param session
     * @param searchTerm The term to match events to.
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "searchEvents.do", method = RequestMethod.GET)
    public @ResponseBody ModelAndView searchEvents(HttpSession session, @RequestParam(value = "searchTerm", required = true) String searchTerm) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/calendar/searchResults");
        
        List<calendarEvents> events = calendarManager.searchEvents(programId, searchTerm);
        
        if(events != null && events.size() > 0) {
            for(calendarEvents event : events) {
                calendarEventTypes eventTypeObject = calendarManager.getEventType(event.getEventTypeId());

                event.setEventColor(eventTypeObject.getEventTypeColor());
            }
        }
        
        mav.addObject("foundEvents", events);
        
        return mav;
        
    }

    @RequestMapping(value = "/getEventTypesDatatable.do", method = RequestMethod.GET)
    public @ResponseBody
    JSONObject getEventTypesDatatable(HttpSession session, HttpServletRequest request) throws Exception {

        JSONObject data = new JSONObject();

        String eventType = request.getParameter("eventType");
        String eventTypeColor = request.getParameter("eventTypeColor");
        String adminOnly = request.getParameter("adminOnly");

        JSONArray eventTypesJSON = calendarManager.returnEventTypesJSON(programId);

        data.put("draw", 1);
        data.put("recordsTotal", eventTypesJSON.size());
        data.put("recordsFiltered", eventTypesJSON.size());
        data.put("aaData", eventTypesJSON);
        data.put("sEcho", 0 + 1);
        data.put("iDisplayLength", eventTypesJSON.size());

        return data;

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

        String from = request.getParameter("start");
        String to = request.getParameter("end");
        String eventTypeId = request.getParameter("eventTypeId");

        JSONArray eventsJSON = calendarManager.getEventsJSON(programId, from, to, eventTypeId);

        data.put("success", 1);
        data.put("result", eventsJSON);

        return eventsJSON;

    }

    @RequestMapping(value = "/saveEvent.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer saveEvent(@ModelAttribute(value = "calendarEvent") calendarEvents calendarEvent, BindingResult errors, @RequestParam(value = "alertAllUsers", required = false, defaultValue = "false") boolean alertUsers, 
            @RequestParam(value = "eventDocuments", required = false) List<MultipartFile> eventDocuments,
            HttpSession session, HttpServletRequest request) throws Exception {

        if (errors.hasErrors()) {
           for(ObjectError error : errors.getAllErrors()) {
               System.out.println(error.getDefaultMessage());
           }
         }
        
        User userDetails = (User) session.getAttribute("userDetails");

        boolean alertAllUsers = false;

        if ("true".equals(alertUsers)) {
            alertAllUsers = true;
        }
        
        /* Need to transfer String start and end date to real date */
        DateFormat format = new SimpleDateFormat("MM/dd/yyyy");
        Date realStartDate = format.parse(calendarEvent.getStartDate());
        Date realEndDate = format.parse(calendarEvent.getEndDate());
        
        calendarEvent.setEventStartDate(realStartDate);
        calendarEvent.setEventEndDate(realEndDate);
        
        if(eventDocuments != null) {
            calendarEvent.setUploadedDocuments(eventDocuments);
        }

        calendarManager.saveEvent(calendarEvent);

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
        
        /* See if there are any existing documents */
        List<calendarEventDocuments> existingDocuments = calendarManager.getEventDocuments(eventDetails.getId());
        
        if(existingDocuments != null) {
            eventDetails.setExistingDocuments(existingDocuments);
        }

        ModelAndView mav = new ModelAndView();
        mav.addObject("calendarEvent", eventDetails);

        User userDetails = (User) session.getAttribute("userDetails");

        if (eventDetails.getSystemUserId() == userDetails.getId()) {
            mav.setViewName("/calendar/newEventModal");

            //List<calendarEventTypes> eventTypes = calendarManager.getEventTypeColors(0);
            List<calendarEventTypes> eventTypes = calendarManager.getEventCategories(programId);
            mav.addObject("eventTypes", eventTypes);

            List<calendarEventTypes> selectedEventTypes = calendarManager.getEventTypeColors(eventId);
            
            for(calendarEventTypes selectedEventType : selectedEventTypes) {
                if("selected".equals(selectedEventType.getSelectedColor())) {
                    mav.addObject("selectedEventTypeColor", selectedEventType.getEventTypeColor());
                }
            }
            
        } else {
            mav.setViewName("/calendar/eventDetailsModal");
            mav.addObject("selectedEventTypeColor","");
        }

        return mav;
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
     * The 'deleteEventDocument' POST request will remove the clicked uploaded document.
     * 
     * @param documentId The id of the clicked document.
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/deleteEventDocument.do", method = RequestMethod.POST) 
    public @ResponseBody Integer deleteEventDocument(@RequestParam(value = "documentId", required = true) Integer documentId) throws Exception {
        
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
        

        return mav;
    }

    @RequestMapping(value = "/getNewEventTypeForm.do", method = RequestMethod.GET)
    public ModelAndView getNewEventTypeForm(HttpSession session, HttpServletRequest request) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/calendar/newEventTypeModal");

        List<calendarEventTypeColors> eventTypeColors = calendarManager.getAllEventTypeColors();

        mav.addObject("colors", eventTypeColors);

        return mav;
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

}
