<%-- 
    Document   : remove_fav
    Created on : 22 Mar, 2022, 10:16:28 AM
    Author     : hp
--%>

<%@page contentType="text/html" import="java.sql.*,java.util.*,java.util.Date;" pageEncoding="UTF-8"%>
<%
  try{
            String email = null;
            Cookie c[] = request.getCookies();
            for(int i=0;i<c.length;i++){
                if(c[i].getName().equals("user")){
                    email = c[i].getValue();
                    break;
                }
            }
            if(email==null){
                    //response.sendRedirect("index.jsp");
                    out.print("index");
            }
            else{
                if(request.getParameter("acode")==null){
                    //response.sendRedirect("index.jsp");
                    out.print("index");
                }
                else{
                    String album_code = request.getParameter("acode");
                    try{
                            Class.forName("com.mysql.jdbc.Driver");
                            Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mp3_jsp","root","");
                            Statement st = cn.createStatement();
                            PreparedStatement ps = cn.prepareStatement("delete from favourite where album_code=?");
                            ps.setString(1, album_code);
                            if(ps.executeUpdate()>0){
                                out.print("success");
                            }
                            cn.close();
                        }
                        catch(ClassNotFoundException e){
                                System.out.println("Driver : "+ e.getMessage());
                        }
                        catch(SQLException ec){
                                System.out.println("SQL : "+ec.getMessage());
                        } 
                    }
            }
   }
   catch(NullPointerException ec){
       out.println(ec.getMessage());
   }
%>

