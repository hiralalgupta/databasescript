package com.ccc.listener;

import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
@WebListener
public class SessionListener implements HttpSessionListener {

	@Override
	public void sessionCreated(HttpSessionEvent se) {
		System.out.println("==== Session is created ====");
		//se.getSession().setMaxInactiveInterval(20);
		
	}

	@Override
	public void sessionDestroyed(HttpSessionEvent se) {
		/*SecurityContextHolder.getContext().setAuthentication(null);
        SecurityContextHolder.clearContext();
        HttpSession hs = se.getSession();
        Enumeration e = hs.getAttributeNames();
        while (e.hasMoreElements()) {
            String attr = (String) e.nextElement();
            hs.setAttribute(attr, null);
        }
      //  removeCookies(request);
        hs.invalidate();*/
		System.out.println("==== Session is destroyed ====");
		
	}

}
