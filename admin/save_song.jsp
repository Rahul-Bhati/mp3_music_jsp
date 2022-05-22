<%@page contentType="text/html" import="java.sql.*,java.util.*,java.util.Date;" pageEncoding="UTF-8"%>
<%
        String email = null;
        Cookie c[] = request.getCookies();
        for(int i=0;i<c.length;i++){
            if(c[i].getName().equals("login")){
                email = c[i].getValue();
                break;
            }
        }
        if(email!=null && session.getAttribute(email)!=null){
            if(request.getParameter("code").length()!=0 && request.getParameter("a").length()!=0 && request.getParameter("d").length()!=0){
                String code = request.getParameter("code");
                String s = request.getParameter("a");
                String d = request.getParameter("d");
                try{
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection cn=DriverManager.getConnection("jdbc:mysql://localhost:3306/mp3_jsp","root","");
                    PreparedStatement ps = cn.prepareStatement("update song set song_name=?,description=? where code=?");
                    ps.setString(1, s);
                    ps.setString(2, d);
                    ps.setString(3, code);
                    if(ps.executeUpdate()>0){
                        out.print("success");
                    }
                    cn.close();
                }
                catch(Exception ec){
                    out.println(ec.getMessage());
                } 
            }         
        }
        else{
            out.print("login");
        }
%>
