<%-- 
    Document   : favourite_page
    Created on : 11 Mar, 2022, 2:25:44 PM
    Author     : hp
--%>

<%@page contentType="text/html" import="java.sql.*,java.util.*;" pageEncoding="UTF-8"%>
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
                try{
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mp3_jsp","root","");
                    %>
                      <div class="al_name"><span><b>Favourite Page</b></span></div><br><br><br>
                      <div class="row">
                    <%
                    Statement st = cn.createStatement();
                    ResultSet rs = st.executeQuery("select * from favourite where email = '"+email+"'");
                    while(rs.next()){
                        Statement st1 = cn.createStatement();
                        ResultSet rs1 = st1.executeQuery("select * from album where code = '"+rs.getString("album_code")+"'");
                        while(rs1.next()){
                    %>		
                            <div class="col-sm-3 video-block" id="d-<%=rs1.getString("code")%>" rel="<%=rs1.getString("album_name")%>" style="cursor:pointer;">
                                <table class="table table-borderless card w3-card" style="width:320px;">
                                    <tr>
                                        <td>
                                            <a><img class="album-img" id="<%=rs1.getString("code")%>" rel="<%=rs1.getString("album_name")%>" src="album/<%=rs1.getString("code")%>.jpg" style="width:300px;height: 200px;"></a>
                                        </td>
                                    </tr>
                                    <tr class="video-name">
                                        <td style="">
                                             <span class="user"><h3><b style="color:black;"><%=rs1.getString("album_name")%></b> 
                                                  <i class='bx bxs-trash' rel="<%=rs1.getString("code")%>" style="color:red"></i>
                                             </span>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                    <%
                        }
                    }
                    %>
                </div>
                <% 
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
    catch(NullPointerException er){
         out.println(er.getMessage());
    }
                
%>





