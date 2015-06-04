/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.calendar;

import com.registryKit.calendar.calendarEventTypeColors;
import com.registryKit.calendar.calendarEventTypes;
import com.registryKit.calendar.calendarEvents;
import com.registryKit.calendar.calendarManager;
import com.registryKit.user.User;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

/**
 *
 * @author chadmccue
 */
@Controller
@RequestMapping("/calendar")
public class calendarController {

    @Autowired
    calendarManager calendarManager;

    @Value("${programId}")
    private Integer programId;

    @Value("${topSecret}")
    private String topSecret;

    @RequestMapping(value = "", method = RequestMethod.GET)
    public ModelAndView calendarHome() throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/calendar");

        List<calendarEventTypes> eventTypes = calendarManager.getEventCategories(programId);

        mav.addObject("eventTypes", eventTypes);

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
    Integer saveEvent(HttpSession session, HttpServletRequest request) throws Exception {

        calendarEvents eventObject = null;

        User userDetails = (User) session.getAttribute("userDetails");

        String eventId = request.getParameter("eventId");
        String eventTypeId = request.getParameter("eventTypeId");
        String eventName = request.getParameter("eventName");
        String eventLocation = request.getParameter("eventLocation");
        String eventStartDate = request.getParameter("eventStartDate");
        String eventEndDate = request.getParameter("eventEndDate");
        String eventStartTime = request.getParameter("eventStartTime");
        String eventEndTime = request.getParameter("eventEndTime");
        String eventNotes = request.getParameter("eventNotes");
        String alertUsers = request.getParameter("alertUsers");

        boolean alertAllUsers = false;

        if ("true".equals(alertUsers)) {
            alertAllUsers = true;
        }

        if (Integer.parseInt(eventId) == 0) {
            eventObject = new calendarEvents();
            eventObject.setProgramId(programId);
            eventObject.setEventTitle(eventName);
            eventObject.setEventLocation(eventLocation);
            eventObject.setSystemUserId(userDetails.getId());

            SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");

            eventObject.setEventStartDate(sdf.parse(eventStartDate));
            eventObject.setEventEndDate(sdf.parse(eventEndDate));
            eventObject.setEventStartTime(eventStartTime);
            eventObject.setEventEndTime(eventEndTime);
            eventObject.setEventNotes(eventNotes);
            eventObject.setEventTypeId(Integer.parseInt(eventTypeId));
        } else {
            /*eventTypeObject = calendarManager.getEventType(Integer.parseInt(eventTypeId));
             eventTypeObject.setProgramId(programId);
             eventTypeObject.setEventType(eventType);
             eventTypeObject.setEventTypeColor(eventTypeColor);
             eventTypeObject.setAdminOnly(isAdminOnly);*/
        }

        calendarManager.saveEvent(eventObject);

        return 1;

    }

    @RequestMapping(value = "/getEventDetails.do", method = RequestMethod.GET)
    public ModelAndView getEventDetails(HttpSession session, HttpServletRequest request) throws Exception {

        Integer eventId = Integer.parseInt(request.getParameter("eventId"));

        calendarEvents eventObject = calendarManager.getEventDetails(eventId);

        calendarEventTypes eventTypeObject = calendarManager.getEventType(eventObject.getEventTypeId());

        eventObject.setEventColor(eventTypeObject.getEventTypeColor());

        ModelAndView mav = new ModelAndView();
        mav.addObject("event", eventObject);

        User userDetails = (User) session.getAttribute("userDetails");

        if (eventObject.getSystemUserId() == userDetails.getId()) {
            mav.setViewName("/calendar/newEventModal");

            List<calendarEventTypes> eventTypes = calendarManager.getEventTypeColors(0);
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

    @RequestMapping(value = "/deleteEvent.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer deleteEvent(HttpSession session, HttpServletRequest request) throws Exception {

        String eventId = request.getParameter("eventId");

        calendarManager.deleteEvent(Integer.parseInt(eventId));

        return 1;

    }

    @RequestMapping(value = "/getNewEventForm.do", method = RequestMethod.GET)
    public ModelAndView getNewEventForm(HttpSession session, HttpServletRequest request) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/calendar/newEventModal");

        List<calendarEventTypes> eventTypes = calendarManager.getEventTypeColors(0);

        mav.addObject("eventTypes", eventTypes);

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
