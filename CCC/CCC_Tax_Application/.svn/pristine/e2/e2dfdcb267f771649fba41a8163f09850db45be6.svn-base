package com.ccc.webapp.security.configuration;

import java.util.Enumeration;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.util.Assert;

public class SessionUtils {
	
	 public static void logout(HttpServletRequest request) {
			Assert.notNull(request, "HttpServletRequest required");
         SecurityContextHolder.getContext().setAuthentication(null);
         SecurityContextHolder.clearContext();
         HttpSession hs = request.getSession();
         Enumeration e = hs.getAttributeNames();
         while (e.hasMoreElements()) {
             String attr = (String) e.nextElement();
             hs.setAttribute(attr, null);
         }
         removeCookies(request);
         hs.invalidate();
     }
	 public static void removeCookies(HttpServletRequest request) {
         Cookie[] cookies = request.getCookies();
         if (cookies != null && cookies.length > 0) {
             for (int i = 0; i < cookies.length; i++) {
                 cookies[i].setMaxAge(0);
             }
         }
     }
}
