              </div>
</div>
          
        </div>
        
          <!-- Footer -->
          <footer class="footer mt-auto">
            <div class="copyright bg-white">
              <p>
                &copy; <span id="copy-year"></span></a>.
              </p>
            </div>
            <script>
                var d = new Date();
                var year = d.getFullYear();
                document.getElementById("copy-year").innerHTML = year;
            </script>
          </footer>

      </div>
    </div>
    
                    



    
                    <script src="source/plugins/jquery/jquery.min.js"></script>
                    <script src="source/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
                    <script src="source/plugins/simplebar/simplebar.min.js"></script>
                    <script src="https://unpkg.com/hotkeys-js/dist/hotkeys.min.js"></script>

                    
                    
                    <script src="source/plugins/apexcharts/apexcharts.js"></script>
                    
                    
                    
                    <script src="source/plugins/DataTables/DataTables-1.10.18/js/jquery.dataTables.min.js"></script>
                    
                    
                    
                    <script src="source/plugins/jvectormap/jquery-jvectormap-2.0.3.min.js"></script>
                    <script src="source/plugins/jvectormap/jquery-jvectormap-world-mill.js"></script>
                    <script src="source/plugins/jvectormap/jquery-jvectormap-us-aea.js"></script>
                    
                    
                    
                    <script src="source/plugins/daterangepicker/moment.min.js"></script>
                    <script src="source/plugins/daterangepicker/daterangepicker.js"></script>
                    <script>
                      jQuery(document).ready(function() {
                        jQuery('input[name="dateRange"]').daterangepicker({
                        autoUpdateInput: false,
                        singleDatePicker: true,
                        locale: {
                          cancelLabel: 'Clear'
                        }
                      });
                        jQuery('input[name="dateRange"]').on('apply.daterangepicker', function (ev, picker) {
                          jQuery(this).val(picker.startDate.format('MM/DD/YYYY'));
                        });
                        jQuery('input[name="dateRange"]').on('cancel.daterangepicker', function (ev, picker) {
                          jQuery(this).val('');
                        });
                      });
                    </script>
                    
                    
                    
                    <script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>
                    
                    
                    
                    <script src="source/plugins/toaster/toastr.min.js"></script>

                    
                    
                    <script src="theme/js/mono.js"></script>
                    <script src="theme/js/chart.js"></script>
                    <script src="theme/js/map.js"></script>
                    <script src="theme/js/custom.js"></script>

                    


                    <!--  -->


  </body>
</html>
