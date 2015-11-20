package com.rr.missouri.ui.security;

import java.util.ArrayList;
import java.util.List;

import org.springframework.security.core.userdetails.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import com.rr.missouri.ui.security.CustomWebAuthenticationDetails.MyAuthenticationDetails;
import com.registryKit.user.userManager;
import org.springframework.beans.factory.annotation.Value;

@Component
public class CustomAuthenticationProvider implements AuthenticationProvider {
    
    @Value("${programId}")
    private Integer programId;

    @Autowired
    private userManager usermanager;

    private String strErrorMessage = "Bad Credentials";

    private String strErrorMessage1 = "Bad Credentials - please check the user. For security purposes, you have been logged out.";

    public CustomAuthenticationProvider() {
        super();
    }

    // API
    @Override
    public Authentication authenticate(final Authentication authentication) throws AuthenticationException {
        final String name = authentication.getName();
        final String password = authentication.getCredentials().toString();
        //we login with email 
        String loginUser = name;
        
        com.registryKit.user.User user = usermanager.getUserByEmail(name, programId);
        com.registryKit.user.User loginUserInfo = user;

        if (user == null) {
            throw new BadCredentialsException(strErrorMessage);
        }
        //check status
        if (!user.getStatus()) {
            throw new BadCredentialsException(strErrorMessage);
        }

        try {
            
            if (usermanager.authenticate(password, user.getEncryptedPw(), user.getRandomSalt())) {
                //password is ok - check to see if user is an admin
                if (user.getRoleId() == 1 || user.getRoleId() == 2) {
                    Object obj = authentication.getDetails();
                    if (obj instanceof MyAuthenticationDetails) {
                        MyAuthenticationDetails details = (MyAuthenticationDetails) obj;
                        if (details.getLoginAsUser() != null) {
                            strErrorMessage = strErrorMessage1;
                            loginUser = details.getLoginAsUser();
                            loginUserInfo = usermanager.getUserByEmail(loginUser);
                            //check status
                            if (!loginUserInfo.getStatus()) {
                                throw new BadCredentialsException(strErrorMessage1);
                            }
                        }
                    }
                }

                final List<GrantedAuthority> grantedAuths = new ArrayList<>();
                //we get authority for login user
                List<String> userRoles = usermanager.getUserRoles(loginUserInfo);
                
                if (userRoles.size() == 0) { 
                    throw new BadCredentialsException(strErrorMessage);
                }
                
                for (String role : userRoles) {
                    grantedAuths.add(new SimpleGrantedAuthority(role));
                }

                final UserDetails principal = new User(loginUser, "", grantedAuths);
                final Authentication auth = new UsernamePasswordAuthenticationToken(principal, "", grantedAuths);
                return auth;

            } else {
                throw new BadCredentialsException(strErrorMessage);
            }
        } catch (Exception ex) {
        	ex.printStackTrace();
            throw new BadCredentialsException(strErrorMessage);       
        }
    }

    @Override
    public boolean supports(final Class<?> authentication) {
        return authentication.equals(UsernamePasswordAuthenticationToken.class);
    }

}
