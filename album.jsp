<%@page contentType="text/html" import="java.sql.*,java.util.*;" pageEncoding="UTF-8"%>
<%
    try{
      int flag = 0;
      String email = null;
      Cookie c[] = request.getCookies();
      for(int i=0;i<c.length;i++){
        if(c[i].getName().equals("user")){
            email = c[i].getValue();
            break;
        }
      }
      if(email!=null){
           flag = 1;
      }
      else{
           flag = 0;
      }   
      if(request.getParameter("cat_code")!=null && request.getParameter("cat_name")!=null){
        String cat_code = request.getParameter("cat_code") ;
        String cat_name = request.getParameter("cat_name") ;
        try{
           Class.forName("com.mysql.jdbc.Driver");
           Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mp3_jsp","root","");
           %>   
        <div class="al_name"><span><%=cat_name%></span></div>
        <br><br><br>
        <div class="row">
            <%
                Statement st = cn.createStatement();
                ResultSet rs = st.executeQuery("select * from album where category_code = '"+cat_code+"'");
                while(rs.next()){
            %>		
                    <div class="col-sm-3 video-block" rel="<%=rs.getString("album_name")%>" style="cursor:pointer;">
                        <table class="table table-borderless card w3-card" style="width:320px;">
                            <tr>
                                <td>
                                    <a><img class="album-img" id="<%=rs.getString("code")%>" rel="<%=rs.getString("album_name")%>" src="album/<%=rs.getString("code")%>.jpg" style="width:300px;height: 200px;"></a>
                                </td>
                            </tr>
                            <tr class="video-name">
                                <td style="">
                                     <span class="user"><h3><b style="color:black;"><%=rs.getString("album_name")%></b> 
                                      <%   
                                         if(flag==1){
                                            String album_code = rs.getString("code");
                                            Statement st1 = cn.createStatement();
                                            ResultSet rs1 = st1.executeQuery("select * from favourite where album_code='"+album_code+"' AND email='"+email+"'");
                                            if(rs1.next()){                                                 
                                      %>
                                                <i class='bx bxs-heart' id="fav-<%=rs.getString("code")%>" rel="<%=rs.getString("code")%>" style="color:red;"></i>
                                       <% 
                                            }
                                            else{
                                             %>
                                                <i class='bx bxs-heart' id="fav-<%=rs.getString("code")%>" rel="<%=rs.getString("code")%>" style="color:#5a5a5a;"></i>
                                               <%
                                            }
                                         }
                                       %>
                                     </span>
                                </td>
                            </tr>
                        </table>
                    </div>
            <%
                }
            %>
        </div>
        <br><br><br>			
<%
                
                cn.close();
            }
            catch(ClassNotFoundException e){
                System.out.println("Driver : "+ e.getMessage());
            }
            catch(SQLException er){
                System.out.println("SQL : "+er.getMessage());
            }
      }
    }
    catch(NullPointerException er){
        response.sendRedirect("index.jsp");
    }  
%>