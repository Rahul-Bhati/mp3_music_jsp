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
            if(request.getParameter("ccode")==null){
                response.sendRedirect("category.jsp?album_code_err=1");
            }
            else{
                String cat_code = request.getParameter("ccode");
                try{
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection cn=DriverManager.getConnection("jdbc:mysql://localhost:3306/mp3_jsp","root","");
                    Statement st = cn.createStatement();
                    ResultSet rs = st.executeQuery("select * from admin where email='"+email+"'");
                    if(rs.next()){
                        Statement st1 = cn.createStatement();
                        ResultSet rs1 = st1.executeQuery("select * from album_category where code='"+cat_code+"'");
                        if(rs1.next()){
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
                    var a = $("#a-"+code).text();
                    var d = $("#des-"+code).text();
                    $("#a-"+code).html("<input type='text' value='"+a+"' id='s-"+code+"' class='form-control' />");
                    $("#des-"+code).html("<textarea type='text' id='sd-"+code+"' class='form-control'>"+d+"</textarea>");
                    $(this).attr("class","fa fa-save");
            });
            $(document).on("click",".fa.fa-save",function(){
                var code = $(this).attr("rel");
                var a = $("#s-"+code).val();
                var d = $("#sd-"+code).val();
                $.post(
                      "save_album.jsp",{code:code,a:a,d:d},function(data){
                            if(data.trim()=="success"){
                                //alert(data);
                                $("#a-"+code).text(a);
                                $("#des-"+code).text(d);
                                $("#"+code).attr("class","fa fa-edit");
                            }
                      }
                );   
            });
            $(document).on("click",".fa.fa-trash",function(){
                var code = $(this).attr("rel");
                $.post(
                      "del_album.jsp",{code:code},function(data){
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
                    <%
                    if(request.getParameter("album_already")!=null){
                        out.println("<h6 class='alert alert-warning'>Album already exist !</h6>");
                      }
                      else if(request.getParameter("album_success")!=null){
                        out.println("<h6 class='alert alert-success'>Album Added Successfully !</h6>");
                      }        
                            
                    %>
                    <div class="container-fluid px-4">
                        <h1 class="mt-4"><b>Admin Panel</b></h1>
                        <ol class="breadcrumb mb-4">
                            <li class="breadcrumb-item active">Album</li>
                        </ol><br><br>			
                        <div class="col-sm-12">
                            <div class="row">
                                <div class="col-sm-6">
                                    <div class="">
                                         <img class="img-fluid" src="../category_image/<%=rs1.getString("code")%>.jpg">
                                    </div>
                                </div>
                                <div class="col-sm-6" style="padding-top: 20px;">
                                    <div class="card bg-primary mb-3">
                                        <div class="card-header">Add Album</div>
                                        <div class="card-body" style="background-color: whitesmoke">
                                            <div id="cat">	
                                                <form method="post" action="add_album.jsp?ccode=<%=cat_code%>" class="form" >
                                                    <label class="form-label" >Album Name</label>
                                                    <input class="form-control"  type="text" name="aname" placeholder="album name" required /><br>
                                                    <label class="form-label" >Description</label>
                                                    <textarea class="form-control" rows="4" name="des" placeholder="description"></textarea><br>
                                                    <a><input type="submit" value="add album" class="w3-btn w3-tiny w3-green w3-round"></a><br><br>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row" >
                        <div class="col-sm-12">
                            <div class="container-fluid px-4" id="search"><br><br>
                                <h2 style="font-family:serif">All Album</h2><br>&nbsp;&nbsp;&nbsp;
                                <div class="col-sm-12" id="alert">
                                <%
                                    ResultSet rs2 = st.executeQuery("select * from album where category_code='"+cat_code+"'");
                                    while(rs2.next()){
                                %>
                                        <table class="table">
                                            <tr id="d-<%=rs2.getString("code")%>">
                                                <td ><img src="../album/<%=rs2.getString("code")%>.jpg" style="width:100px;height:100px;" class="img-"></td>
                                                <td style="width:200px" id="a-<%=rs2.getString("code")%>"><%=rs2.getString("album_name")%></td>
                                                <td style="width:200px" id="des-<%=rs2.getString("code")%>"><%=rs2.getString("description")%></td>
                                                <td>
                                                    <a href="song.jsp?acode=<%=rs2.getString("code")%>&ccode=<%=cat_code%>">
                                                        <button class="w3-btn w3-tiny w3-blue w3-round">Add Song</button>
                                                    </a>
                                                </td>
                                                <td>
                                                    <i class="fa fa-edit" id="<%=rs2.getString("code")%>" rel="<%=rs2.getString("code")%>" style="color:blue;cursor:pointer"></i>
                                                </td>
                                                <td>
                                                    <i class="fa fa-trash" rel="<%=rs2.getString("code")%>" id="delete" style="color:red;cursor:pointer"></i>
                                                </td>
                                            </tr>
                                        </table>
                                <%
                                     }
                                %>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
                <footer class="py-4 bg-light mt-auto">
                    <div class="container-fluid px-4">
                        <div class="d-flex align-items-center justify-content-between small">
                            <div class="text-muted">Copyright &copy; Your Website 2021</div>
                            <div>
                                <a href="#">Privacy Policy</a>
                                &middot;
                                <a href="#">Terms &amp; Conditions</a>
                            </div>
                        </div>
                    </div>
                </footer>
            </div>
        </div>
        <script src="js/scripts.js"></script>
        <script src="js/datatables-simple-demo.js"></script>
    </body>
</html>

<%
                        }
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
    }
    catch(NullPointerException e){
        response.sendRedirect("index.jsp");
    }               
%>
