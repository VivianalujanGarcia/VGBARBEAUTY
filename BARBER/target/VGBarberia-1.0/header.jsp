<%
 HttpSession sesion = request.getSession();
if (sesion.getAttribute("logueado") == null || sesion.getAttribute("logueado").equals("0")) {
%>
<script>
    alert('Ud. debe de identificarse..!!');
    window.location.href = 'index.jsp';
</script>
<%               
} else { // Solo procedemos si el usuario está logueado
    String rol = (String) sesion.getAttribute("rol");
%>
<html lang="en" dir="ltr">
    <head>
    <head>

        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta name="theme-name" content="mono"/>

        <title>VGBARBERIA
        </title>

        <!-- GOOGLE FONTS -->
        <link href="https://fonts.googleapis.com/css?family=Karla:400,700|Roboto" rel="stylesheet">
        <link href="source/plugins/material/css/materialdesignicons.min.css" rel="stylesheet" />
        <link href="source/plugins/simplebar/simplebar.css" rel="stylesheet" />

        <!-- PLUGINS CSS STYLE -->
        <link href="source/plugins/nprogress/nprogress.css" rel="stylesheet" />

        <script src="ajax/jquery-3.7.1.min.js"></script>


        <link href="source/plugins/DataTables/DataTables-1.10.18/css/jquery.dataTables.min.css" rel="stylesheet" />



        <link href="source/plugins/jvectormap/jquery-jvectormap-2.0.3.css" rel="stylesheet" />



        <link href="source/plugins/daterangepicker/daterangepicker.css" rel="stylesheet" />



        <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">



        <link href="source/plugins/toaster/toastr.min.css" rel="stylesheet" />


        <!-- MONO CSS -->
        <link id="main-css-href" rel="stylesheet" href="theme/css/style.css" />




        <!-- FAVICON -->
        <link href="theme/images/VBARBERIA-removebg-preview.png" rel="shortcut icon" />

        <!--
          HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries
        -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
          <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
          <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
        <![endif]-->
        <script src="source/plugins/nprogress/nprogress.js"></script>


    </head>

    <body class="navbar-fixed sidebar-fixed" id="body">
        <script>
    NProgress.configure({showSpinner: false});
    NProgress.start();
        </script>

        <div id="toaster"></div>

        <!-- WRAPPER -->
        <div class="wrapper">
            <aside class="left-sidebar sidebar-dark" id="left-sidebar">
                <div id="sidebar" class="sidebar sidebar-with-footer">
                    <!-- Aplication Brand -->
                    <div class="app-brand">
                        <a href="dashboard.jsp">
                            <img src="theme/images/ESTILO-removebg-preview__2_-removebg-preview (1).png" alt="Mono">
                            <span class="brand-name"><%= rol %></span>
                        </a>
                    </div>
                    <div class="sidebar-left" data-simplebar style="height: 100%;">
                        <ul class="nav sidebar-inner" id="sidebar-menu">
                            <li class="section-title">
                                <% if ("ADMINISTRADOR".equals(rol)) { %>
                                <!-- Código específico para ADMINISTRADOR -->
                            <li  class="has-sub" >
                                <a class="sidenav-item-link" href="javascript:void(0)" data-toggle="collapse" data-target="#referenciales"
                                   aria-expanded="false" aria-controls="referenciales">
                                    <i class="mdi mdi-sitemap"></i>
                                    <span class="nav-text">REFERENCIALES</span> <b class="caret"></b>
                                </a>
                                <ul  class="collapse"  id="referenciales"
                                     data-parent="#sidebar-menu">
                                    <div class="sub-menu">

                                        <li >

                                            <a class="sidenav-item-link" href="usuario.jsp">
                                                <i class="mdi mdi-account"></i>
                                                <span class="nav-text">Usuarios</span>

                                            </a>
                                        </li>

                                         <li
                                            >
                                            <a class="sidenav-item-link" href="ciudades.jsp">
                                                <i class="mdi mdi-city"></i>
                                                <span class="nav-text">Ciudades</span>
                                            </a>
                                        </li>
                                        
                                        
                                        
                                        <li >
                                            <a class="sidenav-item-link" href="personales.jsp">
                                                <i class="mdi mdi-wallet-travel"></i>
                                                <span class="nav-text">Personales</span>

                                            </a>
                                        </li>
                                         <li
                                            >
                                            <a class="sidenav-item-link" href="clientes.jsp">
                                                <i class="mdi mdi-account-multiple"></i>
                                                <span class="nav-text">Clientes</span>
                                            </a>
                                        </li>
                                        <li
                                            >
                                            <a class="sidenav-item-link" href="proveedores.jsp">
                                                <i class="mdi mdi-account-group"></i>
                                                <span class="nav-text">Proveedores</span>
                                            </a>
                                        </li>

                                         <li
                                            >
                                            <a class="sidenav-item-link" href="categorias.jsp">
                                                <i class="mdi mdi-shape-plus"></i>
                                                <span class="nav-text">Categorias</span>
                                            </a>
                                        </li>
                                        
                                        <li
                                            >
                                            <a class="sidenav-item-link" href="marcas.jsp">
                                                <i class="mdi mdi-check-decagram"></i>
                                                <span class="nav-text">Marcas</span>
                                            </a>
                                        </li>
                                        
                                        
                                        
                                        <li >
                                            <a class="sidenav-item-link" href="productos.jsp">
                                                <i class="mdi mdi-package-variant"></i>
                                                <span class="nav-text">Productos</span>
                                            </a>
                                        </li>
                                        
                                         <li
                                            >
                                            <a class="sidenav-item-link" href="banco.jsp">
                                                <i class="mdi mdi-bank"></i>
                                                <span class="nav-text">Banco</span>
                                            </a>
                                        </li>
                                        <li
                                            >
                                            <a class="sidenav-item-link" href="metodopago.jsp">
                                                <i class="mdi mdi-cash-multiple"></i>
                                                <span class="nav-text">Metodos de pago</span>
                                            </a>
                                        </li>

                                       


                                    </div>
                                </ul>

                                <% } %>
                                                    </li>
                                                    <li  class="has-sub" >
                                                        <a class="sidenav-item-link" href="javascript:void(0)" data-toggle="collapse" data-target="#users"
                                                           aria-expanded="false" aria-controls="users">
                                                            <i class="mdi mdi-cart-plus"></i>
                                                            <span class="nav-text">GENERAR COMPRAS</span> <b class="caret"></b>
                                                        </a>
                                                        <ul  class="collapse"  id="users"
                                                             data-parent="#sidebar-menu">
                                                            <div class="sub-menu">

                                                                <li
                                                                    >
                                                                    <a class="sidenav-item-link" href="listarcompra.jsp">
                                                                        <i class="mdi mdi-shopping"></i>
                                                                        <span class="nav-text">COMPRAS</span>
                                                                    </a>
                                                                </li>

                                                            </div>
                                                        </ul>
                                                    </li>

                                                    <li  class="has-sub" >
                                                        <a class="sidenav-item-link" href="javascript:void(0)" data-toggle="collapse" data-target="#authentication"
                                                           aria-expanded="false" aria-controls="authentication">
                                                            <i class="mdi mdi-cart-outline"></i>
                                                            <span class="nav-text">GENERAR VENTAS</span> <b class="caret"></b>
                                                        </a>
                                                        <ul  class="collapse"  id="authentication"
                                                             data-parent="#sidebar-menu">
                                                            <div class="sub-menu">



                                                                <li
                                                                    >
                                                                    <a class="sidenav-item-link" href="listarventas.jsp">
                                                                        <i class="mdi mdi-percent"></i>
                                                                        <span class="nav-text">VENTAS</span>
                                                                    </a>

                                                                </li>


                                                            </div>
                                                        </ul>
                                                    </li>

                                                    <li  class="has-sub" >
                                                        <a class="sidenav-item-link" href="javascript:void(0)" data-toggle="collapse" data-target="#customization"
                                                           aria-expanded="false" aria-controls="customization">
                                                            <i class="mdi mdi-cash-multiple"></i>
                                                            <span class="nav-text">COBROS</span> <b class="caret"></b>
                                                        </a>
                                                        <ul  class="collapse"  id="customization"
                                                             data-parent="#sidebar-menu">
                                                            <div class="sub-menu">


                                                                <li
                                                                    >
                                                                    <a class="sidenav-item-link" href="cobros.jsp">
                                                                        <i class="mdi mdi-cash-100"></i>
                                                                        <span class="nav-text">COBRAR</span>
                                                                    </a>

                                                                </li>


                                                            </div>
                                                        </ul>
                                                    </li>
                                                    <li class="has-sub">
                                                        <a class="sidenav-item-link" href="javascript:void(0)" data-toggle="collapse" data-target="#payments"
                                                           aria-expanded="false" aria-controls="payments">
                                                            <i class="mdi mdi-credit-card"></i>
                                                            <span class="nav-text">PAGOS</span> <b class="caret"></b>
                                                        </a>
                                                        <ul class="collapse" id="payments" data-parent="#sidebar-menu">
                                                            <div class="sub-menu">
                                                                <!-- Aquí puedes agregar los enlaces secundarios relacionados a pagos -->
                                                                 <li
                                                                    >
                                                                    <a class="sidenav-item-link" href="pagos.jsp">
                                                                        <i class="mdi mdi-cash-100"></i>
                                                                        <span class="nav-text">PAGAR</span>
                                                                    </a>

                                                                </li>

                                                            </div>
                                                        </ul>
                                                    </li>
                                                    <li class="has-sub">
                                                        <a class="sidenav-item-link" href="javascript:void(0)" data-toggle="collapse" data-target="#cashbox"
                                                           aria-expanded="false" aria-controls="cashbox">
                                                            <i class="mdi mdi-cash-register"></i>
                                                            <span class="nav-text">CAJAS</span> <b class="caret"></b>
                                                        </a>
                                                        <ul class="collapse" id="cashbox" data-parent="#sidebar-menu">
                                                            <div class="sub-menu">

                                                                <li
                                                                    >
                                                                    <a class="sidenav-item-link" href="abrircaja.jsp">
                                                                        <i class="mdi mdi-cash-register"></i>
                                                                        <span class="nav-text">APERTURA CAJA</span>
                                                                    </a>

                                                                </li>
                                                                 <li
                                                                    >
                                                                     <a class="sidenav-item-link" href="movimientocaja_1.jsp">
                                                                         <i><img src="img/mov-removebg-preview (1).png" ></i>
                                                                        <span class="nav-text">MOVIMIENTO CAJA</span>
                                                                    </a>

                                                                </li>
                                                                <li
                                                                    >
                                                                    <a class="sidenav-item-link" href="cerrarcaja.jsp">
                                                                        <i><img src="img/caja-registradora (6).png" ></i>
                                                                        <span class="nav-text">CIERRE CAJA</span>
                                                                    </a>

                                                                </li>
                                                            </div>
                                                        </ul>
                                                    </li>


                                                    
                                                    
                                                    
                                                    
                                                    <li  class="has-sub" >
                                                        <a class="sidenav-item-link" href="javascript:void(0)" data-toggle="collapse" data-target="#email"
                                                           aria-expanded="false" aria-controls="email">
                                                            <i class="mdi mdi-chart-bar"></i>
                                                            <span class="nav-text">INVENTARIO</span> <b class="caret"></b>
                                                        </a>
                                                        <ul  class="collapse"  id="email"
                                                             data-parent="#sidebar-menu">
                                                            <div class="sub-menu">



                                                                <li >
                                                                    <a class="sidenav-item-link" href="listarajuste.jsp">
                                                                        <i class="mdi mdi-cached"></i>
                                                                        <span class="nav-text">AJUSTE DE INVENTARIO</span>

                                                                    </a>
                                                                </li>

                                                            </div>
                                                        </ul>
                                                    </li>

                                                    <li class="has-sub">
                                                        <a class="sidenav-item-link" href="javascript:void(0)" data-toggle="collapse" data-target="#informe"
                                                           aria-expanded="false" aria-controls="informe">
                                                            <i class="mdi mdi-file-chart"></i>
                                                            <span class="nav-text">INFORME</span> <b class="caret"></b>
                                                        </a>
                                                        <ul class="collapse" id="informe" data-parent="#sidebar-menu">
                                                            <div class="sub-menu">
                                                                 <li>
                                                                    <a class="sidenav-item-link" href="INFORMEVENTAS.jsp">
                                                                        <i class="mdi mdi-file-check"></i>
                                                                        <span class="nav-text">INFORME VENTAS</span>
                                                                    </a>
                                                                </li>
                                                                <li>
                                                                    <a class="sidenav-item-link" href="informeventadetalle.jsp">
                                                                        <i class="mdi mdi-file-check"></i>
                                                                        <span class="nav-text">INFORME DETALLE VENTAS</span>
                                                                    </a>
                                                                </li>
                                                                 <li>
                                                                    <a class="sidenav-item-link" href="INFORMECOMPRAS.jsp">
                                                                        <i class="mdi mdi-file-check"></i>
                                                                        <span class="nav-text">INFORME COMPRAS</span>
                                                                    </a>
                                                                </li>
                                                                 <li>
                                                                    <a class="sidenav-item-link" href="informedetallecompra.jsp">
                                                                        <i class="mdi mdi-file-check"></i>
                                                                        <span class="nav-text">INFORME DETALLE COMPRAS</span>
                                                                    </a>
                                                                </li>
                                                                 <li>
                                                                    <a class="sidenav-item-link" href="INFORMECOBRO.jsp">
                                                                        <i class="mdi mdi-file-check"></i>
                                                                        <span class="nav-text">INFORME COBROS</span>
                                                                    </a>
                                                                </li>
                                                                 <li>
                                                                    <a class="sidenav-item-link" href="detallecobros.jsp">
                                                                        <i class="mdi mdi-file-check"></i>
                                                                        <span class="nav-text">INFORME DETALLE COBROS</span>
                                                                    </a>
                                                                </li>
                                                                <li>
                                                                    <a class="sidenav-item-link" href="INFORMEPAGOS.jsp">
                                                                        <i class="mdi mdi-file-check"></i>
                                                                        <span class="nav-text">INFORME PAGOS</span>
                                                                    </a>
                                                                </li>
                                                                 <li>
                                                                    <a class="sidenav-item-link" href="detallepagos.jsp">
                                                                        <i class="mdi mdi-file-check"></i>
                                                                        <span class="nav-text">INFORME DETALLE PAGOS</span>
                                                                    </a>
                                                                </li>
                                                                <li>
                                                                    
                                                                    <a class="sidenav-item-link" href="ventasfinalizadas.jsp">
                                                                        <i class="mdi mdi-file-check"></i>
                                                                        <span class="nav-text">VENTAS FINALIZADAS</span>
                                                                    </a>
                                                                </li>
                                                                <li>
                                                                    <a class="sidenav-item-link" href="ventasanuladas.jsp">
                                                                        <i class="mdi mdi-file-check"></i>
                                                                        <span class="nav-text">VENTAS ANULADAS</span>
                                                                    </a>
                                                                </li>
                                                                <li>
                                                                    <a class="sidenav-item-link" href="ventascanceladas.jsp">
                                                                        <i class="mdi mdi-file-check"></i>
                                                                        <span class="nav-text">VENTAS CANCELADAS</span>
                                                                    </a>
                                                                </li>
                                                                <li>
                                                                    <a class="sidenav-item-link" href="comprasfinalizadas.jsp">
                                                                        <i class="mdi mdi-file-check"></i>
                                                                        <span class="nav-text">COMPRAS FINALIZADAS</span>
                                                                    </a>
                                                                </li>
                                                                <li>
                                                                    <a class="sidenav-item-link" href="comprasanuladas.jsp">
                                                                        <i class="mdi mdi-file-check"></i>
                                                                        <span class="nav-text">COMPRAS ANULADAS</span>
                                                                    </a>
                                                                </li>
                                                                <li>
                                                                    <a class="sidenav-item-link" href="comprascanceladas.jsp">
                                                                        <i class="mdi mdi-file-check"></i>
                                                                        <span class="nav-text">COMPRAS CANCELADAS</span>
                                                                    </a>
                                                                </li>
                                                            </div>
                                                        </ul>

                                                    </li>




                        </ul>
                    </div>
                </div>
            </aside>

            <div class="page-wrapper">
                
                        <!-- Header -->
                <header class="main-header" id="header">
                    <nav class="navbar navbar-expand-lg navbar-light" id="navbar">
                        <!-- Sidebar toggle button -->
                        <button id="sidebar-toggler" class="sidebar-toggle">
                            <span class="sr-only">Toggle navigation</span>
                        </button>

                        <span class="page-title">dashboard</span>
                             <div class="navbar-right">
                        <ul class="nav navbar-nav">
                            <!-- User Account Dropdown - Perfil -->
                            <li class="dropdown user-menu">
                                <button class="dropdown-toggle nav-link" data-toggle="dropdown">
                                    <img src="img/perfil-del-usuario (2).png"/>
                                    <span class="d-none d-lg-inline-block"><% out.print(sesion.getAttribute("dato")); %></span>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-right">
                               
                                    <a class="dropdown-item" ><% out.print(sesion.getAttribute("rol")); %></i></a>
                                    <li><a class="dropdown-item" href="jsp/logout.jsp"><i class="mdi mdi-logout"></i>Cerrar Sesión</a></li>
                                </ul>
                            </li>

                         
                        </ul>
                    </div>
         
                        
                      
                    </nav>


            
                </header>

              
<% 
} 
%>
