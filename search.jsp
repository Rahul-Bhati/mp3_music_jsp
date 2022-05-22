<%-- 
    Document   : search
    Created on : 11 Mar, 2022, 8:54:04 AM
    Author     : hp
--%>

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
        if(request.getParameter("sch")==null){
            //response.sendRedirect("index.jsp");
            out.print("index");
        }
        else{
            String search = request.getParameter("sch"); 
            String s[] = search.split(" ");
            String sql = "select * from album where album_name like '%"+search+"%' OR description like '%"+search+"%' and status='0'";
            for(int i=0;i<s.length;i++){
                sql = sql+"OR album_name like '%"+s[i]+"%' OR description like '%"+s[i]+"%' and status='0'";
            }
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mp3_jsp","root","");
                Statement st = cn.createStatement();
                ResultSet rs = st.executeQuery(sql);
               %>
               <div class="row">
               <%
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


