package com.rr.missouri.ui.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.ServletException;

import java.io.IOException;
import java.util.Set;
import com.registryKit.user.userManager;
import com.registryKit.user.User;
import com.registryKit.user.userProgramModules;
import com.registryKit.program.modules;
import com.registryKit.program.program;
import com.registryKit.program.programManager;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;


import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Value;

public class CustomAuthenticationHandler extends SimpleUrlAuthenticationSuccessHandler {
    
    @Value("${programId}")
    private Integer programId;

    @Autowired
    private userManager usermanager;
    
    @Autowired
    private programManager programmanager;
    
    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws ServletException, IOException {
        
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());

        usermanager.setLastLogin(authentication.getName());
        
        HttpSession session = request.getSession();

        if (roles.contains("ROLE_USER") || roles.contains("ROLE_PROGRAMADMIN")) {
            // Need to get the userId 
            User userDetails = usermanager.getUserByUsername(authentication.getName(), programId);
           
            // Need to store the user object in session 
            session.setAttribute("userDetails", userDetails);
            
            List<program> availPrograms = null;
            String[][] availablePrograms = null;
            try {
                availPrograms = programmanager.getProgramsByAdminisrator(userDetails.getId());
               
                if(!availPrograms.isEmpty()) {
                    availablePrograms = new String[availPrograms.size()][2];
                    int index = 0;
                    for(program program : availPrograms) {
                        if(program.getId() != programId) {
                            availablePrograms[index][0] = program.getUrl();
                            availablePrograms[index][1] = program.getProgramName();
                            index++;
                        }
                    }
                }
                
            } catch (Exception ex) {
                Logger.getLogger(CustomAuthenticationHandler.class.getName()).log(Level.SEVERE, null, ex);
            }
           
            session.setAttribute("availPrograms", availablePrograms);
            
            List<userProgramModules> availModules = null;
            String[][] programModules = null;
            try {
                availModules = usermanager.getUsedModulesByUser(programId, userDetails.getId(), userDetails.getRoleId());
               
                if(!availModules.isEmpty()) {
                    programModules = new String[availModules.size()][4];
                    int index = 0;
                    for(userProgramModules module : availModules) {
                        modules moduleDetails = programmanager.getProgramModuleById(module.getModuleId());
                        programModules[index][0] = moduleDetails.getModuleName();
                        programModules[index][1] = moduleDetails.getDisplayName();
                        programModules[index][2] = moduleDetails.getLinkIcon();
                        programModules[index][3] = Integer.toString(moduleDetails.getId());
                        index++;
                    }
                }
                
            } catch (Exception ex) {
                Logger.getLogger(CustomAuthenticationHandler.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            session.setAttribute("availModules", programModules);
            
            getRedirectStrategy().sendRedirect(request, response, "/home");
        }
        else {
            super.onAuthenticationSuccess(request, response, authentication);
            return;
        }
    }
}
