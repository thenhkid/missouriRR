/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.forum;

import com.registryKit.forum.forumMessages;
import java.util.Date;
import java.util.List;

/**
 *
 * @author chadmccue
 */
public class topicMessages implements Comparable<topicMessages> {

    private Date messageDate;

    List<forumMessages> messages;

    public Date getMessageDate() {
        return messageDate;
    }

    public void setMessageDate(Date messageDate) {
        this.messageDate = messageDate;
    }

    public List<forumMessages> getMessages() {
        return messages;
    }

    public void setMessages(List<forumMessages> messages) {
        this.messages = messages;
    }

    public int compareTo(topicMessages m1) {
        return getMessageDate().compareTo(m1.getMessageDate());
    }

}
