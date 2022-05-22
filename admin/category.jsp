<%-- 
    Document   : category
    Created on : 10 May, 2022, 10:54:09 AM
    Author     : hp
--%>

<%@page contentType="text/html" import="java.sql.*" pageEncoding="UTF-8"%>

<%
  try{
        String email = null;
        Cookie c[] = request.getCookies();
        for(int i=0;i<c.length;i++){
            if(c[i].getName().equals("login")){
                email = c[i].getValue();
                break;
            }
        }
        if(email==null && session.getAttribute(email)==null){
            response.sendRedirect("index.jsp");
        }
        else{
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection cn=DriverManager.getConnection("jdbc:mysql://localhost:3306/mp3_jsp","root","");
                Statement st = cn.createStatement();
                ResultSet rs = st.executeQuery("select * from admin where email='"+email+"'");
                if(rs.next()){
    
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>My Music</title>
        <link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
        <link href="css/styles.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
        <script src="https://use.fontawesome.com/09901d9403.js"></script>
        <link rel="shortcut icon" href="favi.png" />
        <style>
            textarea{
                resize: none;
            }
        </style>
        <script>
            $(document).on("click",".fa.fa-edit",function(){
                    var code = $(this).attr("rel");
                    var cat = $("#cat-"+code).text();
                    $("#cat-"+code).html("<input type='text' value='"+cat+"' id='s-"+code+"' class='form-control' />");
                    $(this).attr("class","fa fa-save");
            });
            $(document).on("click",".fa.fa-save",function(){
                var code = $(this).attr("rel");
                var cat = $("#s-"+code).val();
                $.post(
                      "update_category.jsp",{code:code,cat:cat},function(data){
                            if(data.trim()=="success"){
                                $("#cat-"+code).text(cat);
                                $("#"+code).attr("class","fa fa-edit");
                            }
                            else if(data.trim()=="login"){
                                $("#alert").html("<h3 class='alert alert-warning'>Logout Successfully !</h3>");
                            }
                      }
                );
                
            });
            $(document).on("click",".fa.fa-trash",function(){
                var code = $(this).attr("rel");
                $.post(
                      "del_category.jsp",{code:code},function(data){
                            if(data.trim()=="success"){
                                $("#d-"+code).fadeOut(500);
                            }
                            else if(data.trim()=="login"){
                                $("#alert").html("<h3 class='alert alert-warning'>Logout Successfully !</h3>");
                            }
                      }
                );
            });
        </script>
    </head>
    <body class="sb-nav-fixed">
        <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
            <!-- Navbar Brand-->
            <a class="navbar-brand ps-3" href="dashboard.jsp">My Music</a>
            <!-- Sidebar Toggle-->
            <button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0" id="sidebarToggle" href="#!"><i class="fa fa-bars"></i></button>
        </nav>
        <div id="layoutSidenav">
            <div id="layoutSidenav_nav">
                <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
                    <div class="sb-sidenav-menu">
                        <div class="nav">
                            <div class="sb-sidenav-menu-heading">Core</div>
                            <a class="nav-link" href="dashboard.jsp">
                                <div class="sb-nav-link-icon"><i class="fa fa-tachometer" aria-hidden="true"></i></div>
                                Dashboard
                            </a>
                            <div class="sb-sidenav-menu-heading">Interface</div>
                            <a class="nav-link" href="category.jsp"><i class="fa fa-book" aria-hidden="true"></i>&nbsp;&nbsp;Category</a>
                            <a class="nav-link" href="logout.jsp"><i class="fa fa-sign-out"></i>&nbsp;&nbsp;Logout</a>
                        </div>
                    </div>
                    <div class="sb-sidenav-footer">
                        <div class="small">Logged in as:</div>
                        <%=rs.getString("email")%>
                    </div>
                </nav>
            </div>
            <div id="layoutSidenav_content">
                <main id="record">
                    <span id="store" prel="" pid="" prec="0">
                        <%
                            if(request.getParameter("img_success")!=null){
                              out.println("<h6 class='alert alert-success'>Image Uploaded Successfully !</h6>");
                            }
                            else if(request.getParameter("img_error")!=null){
                              out.println("<h6 class='alert alert-danger'>Image Not Uploaded !</h6>");
                            }
                            else if(request.getParameter("code_invalid")!=null){
                              out.println("<h6 class='alert alert-warning'>Try Again !</h6>");
                            }
                            else if(request.getParameter("album_code_err")!=null){
                              out.println("<h6 class='alert alert-warning'>Try Again !</h6>");
                            }
                        %>
                    </span>
                    <div class="container-fluid px-4">
                        <h1 class="mt-4"><b>Admin Panel</b></h1>
                        <ol class="breadcrumb mb-4">
                            <li class="breadcrumb-item active">All Category</li>
                        </ol><br><br>
                        <div class="row" >
                        <div class="col-sm-12">
                            <div class="container-fluid px-4">
                                <%
                                    ResultSet rs1 = st.executeQuery("select * from album_category");
                                    while(rs1.next()){
                                        %>
                                        <table class="table ">
                                            <tr id="d-<%=rs1.getString("code")%>">
                                                <td style="width:200px" id="">
                                                    <img src="../category_image/<%=rs1.getString("code")%>.jpg" class="img-fluid" style="width:100px;height: 100px">
                                                    <br><br><a href="cat_img_page.jsp?code=<%=rs1.getString("code")%>"><button class="w3-btn w3-tiny w3-yellow w3-round">Change image</button></a>
                                                </td>                                                
                                                <td style="width:100px;padding-top:25px;" id="cat-<%=rs1.getString("code")%>"><%=rs1.getString("category_name")%></td>                                                
                                                <td style="width:100px;padding-top:25px;" >
                                                    <a href="album.jsp?ccode=<%=rs1.getString("code")%>"><button class="w3-btn w3-tiny w3-blue w3-round">Add Album</button></a>
                                                </td>                                                
                                                <td  style="width:100px;padding-top:25px;">
                                                    <i class="fa fa-edit" id="<%=rs1.getString("code")%>" rel="<%=rs1.getString("code")%>" title="edit" style="color:blue;cursor:pointer" ></i>&nbsp;&nbsp;&nbsp;&nbsp;
                                                    <i class="fa fa-trash" rel="<%=rs1.getString("code")%>" title="delete" style="color:red;cursor:pointer"></i>
                                                </td>
                                            </tr>
                                        </table>
                                           <%
                                    }
                                %>
                                </div>
                            </div>
                        </div>
                    </div><br><br>
                </main>
                <footer class="py-4 bg-light mt-auto">
                    <div class="container-fluid px-4">
                        <div class="d-flex align-items-center justify-content-between small">
                            <div class="text-muted">Copyright &copy; Your Website 2022</div>
                            <div>
                                <a href="#">Privacy Policy</a>
                                &middot;
                                <a href="#">Terms &amp; Conditions</a>
                            </div>
                        </div>
                    </div>
                </footer>
            
        </div>
        <script src="js/scripts.js"></script>
        <script src="js/datatables-simple-demo.js"></script>
    </body>
</html>

<%
                    }
                    else{
                        response.sendRedirect("index.jsp?email_invalid=1");
                    }
                    cn.close();
               }
               catch(Exception ec){
                 out.println(ec.getMessage());
               } 
         }
    }
    catch(NullPointerException e){
        response.sendRedirect("index.jsp");
    }               
%>
