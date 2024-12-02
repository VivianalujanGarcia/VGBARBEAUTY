<%@ include file="header.jsp" %>
<script src="ajax/metodopago.js"></script>
<!--<div id="qrcode"></div>
<script src="https://cdn.jsdelivr.net/gh/davidshimjs/qrcodejs/qrcode.min.js"></script>
<script>
    var qrcode = new QRCode(document.getElementById("qrcode"), {
        text: "https://ejemplo.com/metodo-pago",
        width: 128,
        height: 128,
    });
</script>-->

<style>
        body {
            background-color: #FFFFFF; /* Color de fondo */
            font-family: 'Karla', sans-serif; /* Fuente principal */
            margin: 0;
            padding: 0;
        }
 </style>
<div class="row">
    <!-- Formulario de Método de Pago -->
    <div class="col-md-6">
        <div class="card">
            <div class="card-body">
                <form id="form">
                    <h5 class="card-title mb-0">Formulario Método de Pago</h5>
                    <input type="hidden" name="listar" id="listar" value="cargar">
                    <input type="hidden" name="pk" id="pk">
                     <div class=" form-group ">
                        <label for="condicion">Método:</label>
                        <select class="form-control" name="metodo" id="metodo">
                            <option value="">Selecciona un metodo de pago</option>
                            <option value="Tarjeta de Crédito">Tarjeta de Crédito</option>
                            <option value="Transferencia Bancaria">Transferencia Bancaria</option>
                            <option value="Efectivo">Efectivo</option>
                            <option value="QR">QR</option>
                            <option value="Cheque">Cheque</option>
                            
                        </select>
                    </div>
                    <!--<div class="mb-3">
                        <label for="metodo" class="form-label">Método:</label>
                        <input type="text" id="metodo" name="metodo" class="form-control" required>
                    </div> -->
                    
                    <div class=" form-group ">
                        <label for="condicion">Banco:</label>
                        <select class="form-control" name="banco" id="banco">
                            <option value="">Selecciona un Banco</option>
                            <option value="Itau">Itau</option>
                            <option value="Ueno">Ueno</option>
                             <option value="-">-</option>
                            <option value="Continental">Continental</option>
                            <option value="Familiar">Familiar</option>
                            <option value="Regional">Regional</option>
                            <option value="Atlas">Atlas</option>
                        </select>
                    </div>
                     
                    <button type="button" id="boton" name="boton" class="btn btn-success">Cargar</button>
                    <div id="mensajealer" class="alert" style="display: none;"></div>
                    <div id="mensaje" class="mt-3"></div>
                </form>
            </div>
        </div>
    </div>

    <!-- Listado de Métodos de Pago -->
    <div class="col-md-6">
        <div class="card">
            <div class="card-body">
                <h1>Listado de Métodos de Pago <button class="btn btn-outline-secondary" data-ciudades="1" title="Imprimir" data-toggle="modal" data-target="#Imprimirl">
    Imprimir Listado General <img src="img/impresora (1).png" title="Imprimir">
</button></h1>
                <table class="table" id="resultado">
                    <thead>
                        <tr>
                            <th scope="col">Id</th>
                            <th scope="col">Método</th>
                            <th scope="col">Banco</th>
                            <th scope="col">Acción</th>
                        </tr>
                    </thead>
                    <tbody>

                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Modal -->
<div id="Eliminar" class="modal fade" role="dialog">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-secondary text-white">
                <h4 class="modal-title text-white">Eliminar Registro</h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <form id="eliminar" action="#" method="post">
                <input type="hidden" name="eliminars" id="eliminars" value="eliminars">
                <div class="modal-body">
                    <p class="text-secondary">¿Estás seguro de que deseas eliminar este registro?</p>
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
                    <button type="submit" class="btn btn-primary" name="imprimirtodo" id="imprimirtodo" data-dismiss="modal">Imprimir</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!--**********************************
    Modal Imprimir Reporte General 
***********************************-->

<div id="Imprimirl" class="modal fade" role="dialog">
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
                    <input type="hidden" name="ciudades" id="ciudades">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-primary" name="imprimi" id="imprimi">Imprimir</button>
                </div>
            </form>
        </div>
    </div>
</div>



<!-- Modal Agregar Método de Pago -->
<div id="agregarMetodoModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="agregarMetodoModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-secondary text-white">
                <h5 class="modal-title" id="agregarMetodoModalLabel">Agregar Método de Pago</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Cerrar">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="formAgregarMetodo">
                    <div class="form-group">
                        <label for="metodo">Método:</label>
                        <input type="text" class="form-control" name="metodo" id="metodoModal" required>
                    </div>

                    <div class="form-group">
                        <label for="banco">Banco:</label>
                        <input type="text" class="form-control" name="banco" id="bancoModal" required>
                    </div>
                    
                    <button type="submit" class="btn btn-success">Agregar</button>
                </form>
            </div>
        </div>
    </div>
</div>





<%@ include file="footer.jsp" %>
