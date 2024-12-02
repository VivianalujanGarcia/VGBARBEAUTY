<%@ include file="header.jsp" %>
<script src="ajax/productos.js"></script>
<style>
    body {
        background-color: #FFFFFF; /* Color de fondo */
        font-family: 'Karla', sans-serif; /* Fuente principal */
        margin: 0;
        padding: 0;
    }

    .container-fluid {
        margin-top: 20px;
    }

    .form-control {
        margin-bottom: 1rem;
    }

    /* Ajuste de las columnas en dispositivos pequeños */
    .col-form-label {
        font-weight: bold;
    }

    /* Asegurar que la tabla sea responsiva */
    .table-responsive {
        overflow-x: auto;
    }

    /* Estilos adicionales para la visualización móvil */
    @media (max-width: 767px) {
        .col-md-3, .col-md-8 {
            padding-left: 0 !important;
            padding-right: 0 !important;
        }

        .btn {
            font-size: 12px; /* Botones más pequeños */
        }

        /* Ajustar el padding de la tabla */
        .table td, .table th {
            padding: 0.3rem;
        }

        /* Para el título del listado */
        h1 {
            font-size: 18px;
            text-align: center;
        }
    }

    /* Para pantallas más pequeñas, aseguramos un tamaño adecuado en los modales */
    @media (max-width: 576px) {
        h1 {
            font-size: 16px;
        }
    }

    /* Estilos para los modales */
    .modal-dialog {
        max-width: 600px; /* Modales con un tamaño normal */
        width: 100%;
    }

    /* Centrar el modal en pantallas grandes y pequeñas */
    .modal-content {
        border-radius: 10px;
    }

    .modal-header {
        background-color: #6c757d;
        color: white;
    }

    .modal-footer {
        display: flex;
        justify-content: space-between;
    }

</style>

<div class="container-fluid">
    <div class="row">
        <!-- Formulario de Productos -->
        <div class="col-12 col-md-4">
            <div class="card">
                <div class="card-body">
                    <form id="form">
                        <h5 class="card-title mb-0">Formulario Productos</h5>
                        <input type="hidden" name="listar" id="listar" value="cargar">
                        <input type="hidden" name="pk" id="pk">

                        <!-- Nombre -->
                        <div class="mb-3">
                            <label for="nombre" class="form-label">Nombre:</label>
                            <input type="text" id="nombre" name="nombre" class="form-control" required>
                        </div>

                        <!-- Descripción -->
                        <div class="mb-3">
                            <label for="descripcion" class="form-label">Descripción:</label>
                            <textarea id="descripcion" name="descripcion" class="form-control" rows="3" required></textarea>
                        </div>

                        <!-- Precio y Cantidad -->
                        <div class="row mb-3">
                            <div class="col-12 col-sm-6">
                                <label for="precio" class="form-label">Precio:</label>
                                <input type="number" id="precio" name="precio" class="form-control" required>
                            </div>
                            <div class="col-12 col-sm-6">
                                <label for="cantidad" class="form-label">Cantidad:</label>
                                <input type="number" id="cantidad" name="cantidad" class="form-control" required>
                            </div>
                        </div>

                        <!-- Categoría, Marca, IVA -->
                        <div class="row mb-3">
                            <div class="col-12 col-sm-6">
                                <label for="id_categoria" class="form-label">Categoría ID:</label>
                                <select type="select-control" id="id_categoria" name="id_categoria" class="form-control" required></select>
                            </div>
                            <div class="col-12 col-sm-6">
                                <label for="id_marca" class="form-label">Marca ID:</label>
                                <select type="select-control" id="id_marca" name="id_marca" class="form-control" required></select>
                            </div>
                            <div class="col-12 col-sm-6">
                                <label for="iva" class="form-label">IVA:</label>
                                <input type="number" id="iva" name="iva" class="form-control" required>
                            </div>
                        </div>

                        <!-- Botón Guardar -->
                        <input type="button" id="boton" name="boton" class="btn btn-success w-100" value="Guardar">
                        <div id="mensaje" class="mt-3"></div>
                        <div id="mensajealer" class="alert" style="display: none;"></div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Listado de Productos -->
        <div class="col-12 col-md-8">
            <h1>Listado de Productos 
                <button class="btn btn-outline-secondary" title="Imprimir" data-toggle="modal" data-target="#Imprimirl">
                    Imprimir Listado General <img src="img/impresora (1).png" title="Imprimir">
                </button>
            </h1>

            <!-- Tabla Responsiva -->
            <div class="table-responsive">
                <table class="table" id="resultado">
                    <thead>
                        <tr>
                            <th scope="col">ID</th>
                            <th scope="col">Nombre</th>
                            <th scope="col">Descripción</th>
                            <th scope="col">Precio</th>
                            <th scope="col">Cantidad</th>
                            <th scope="col">IVA</th>
                            <th scope="col">Categoría ID</th>
                            <th scope="col">Marca ID</th>
                            <th scope="col">Acción</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Aquí se llenarán dinámicamente las filas con datos de la base de datos -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Modal de Eliminación -->
<div id="Eliminar" class="modal fade" role="dialog">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-secondary text-white">
                <h4 class="modal-title text-white">Eliminar Producto</h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <form id="eliminar" action="#" method="post">
                <input type="hidden" name="eliminars" id="eliminars" value="eliminars">
                <div class="modal-body">
                    <p class="text-secondary">¿Estás seguro de que deseas eliminar este producto?</p>
                    <input type="hidden" name="pkdel" id="pkdel">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary" name="eliminartodo" id="eliminartodo" data-dismiss="modal">Eliminar</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal de Imprimir -->
<div id="Imprimir" class="modal fade" role="dialog">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-secondary text-white">
                <h4 class="modal-title text-white">Imprimir Registro</h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <form id="imprimir" action="#" method="post">
                <input type="hidden" name="imprimirs" id="imprimirs" value="imprimirs">
                <div class="modal-body">
                    <p class="text-secondary">¿Estás seguro de que deseas Imprimir este registro?</p>
                    <input type="hidden" name="pkim" id="pkim">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-primary" name="imprimi" id="imprimi">Imprimir</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
