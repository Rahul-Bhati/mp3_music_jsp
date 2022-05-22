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
            if(request.getParameter("code").length()!=0){
                String code = request.getParameter("code");
                try{
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection cn=DriverManager.getConnection("jdbc:mysql://localhost:3306/mp3_jsp","root","");
                    PreparedStatement ps = cn.prepareStatement("delete from album where code=?");
                    ps.setString(1, code);
                    if(ps.executeUpdate()>0){
                        Statement st1 = cn.createStatement();
                        ResultSet rs1 = st1.executeQuery("select * from song where album_code='"+code+"'");
                        if(rs1.next()){
                            PreparedStatement ps2 = cn.prepareStatement("delete from song where album_code=?");
                            ps2.setString(1, code);
                            if(ps2.executeUpdate()>0){
                                out.print("success");
                            }
                        }
                        else{
                            out.print("success");
                        }
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
