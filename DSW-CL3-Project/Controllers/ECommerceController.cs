using Microsoft.AspNetCore.Mvc;
using System.Data;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.Session;
using Newtonsoft.Json;
using DSW_CL3_Project.Models;

namespace DSW_CL3_Project.Controllers
{
    public class ECommerceController : Controller
    {
        private readonly IConfiguration _config;
        public ECommerceController(IConfiguration Iconfig)
        {
            _config = Iconfig;
        }

        IEnumerable<ProductoModel> productos()
        {
            List<ProductoModel> lista = new List<ProductoModel>();

            using (SqlConnection cn = new SqlConnection(_config["ConnectionString"]))
            {
                using (SqlCommand cmd = new SqlCommand("exec usp_productos", cn))
                {
                    try
                    {
                        cn.Open();
                        Console.WriteLine("¡Conexión exitosa a la base de datos!");

                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                lista.Add(new ProductoModel()
                                {
                                    IdProducto = dr.GetInt32(0),
                                    Nombre = dr.GetString(1),
                                    Descripcion = dr.GetString(2),
                                    DescripcionMarca = dr.GetString(3),
                                    DescripcionCategoria = dr.GetString(4),
                                    Precio = dr.GetDecimal(5),
                                    Stock = dr.GetInt32(6),
                                    RutaImagen = dr.GetString(7),
                                    Activo = dr.GetBoolean(8),
                                });
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        // Manejar la excepción, imprimir o registrar algún mensaje de error
                        Console.WriteLine($"Error al abrir la conexión: {ex.Message}");
                    }
                }
            }

            return lista;
        }

        ProductoModel? Buscar(int id = 0)
        {
            ProductoModel? reg = productos().Where(p => p.IdProducto == id).FirstOrDefault();
            if (reg == null)
                reg = new ProductoModel();

            return reg;
        }

        public async Task<IActionResult> portal()
        {
            if (HttpContext.Session.GetString("Carrito") == null)
                HttpContext.Session.SetString("Carrito", JsonConvert.SerializeObject(new List<ItemModel>()));

            return View(await Task.Run(() => productos()));
        }

        public async Task<IActionResult> Agregar(int id = 0)
        {
            return View(await Task.Run(() => Buscar(id)));
        }

        [HttpPost] public ActionResult Agregar(int codigo, int cantidad)
        {
            ProductoModel reg = Buscar(codigo);
            if (cantidad > reg.Stock)
            {
                ViewBag.mensaje = string.Format("El producto solo dispone de {0} unidades", reg.Stock);
            }

            ItemModel it = new ItemModel();
            it.IdProducto = codigo;
            it.Nombre = reg.Nombre;
            it.Descripcion = reg.Descripcion;
            it.Marca = reg.DescripcionMarca;
            it.Categoria = reg.DescripcionCategoria;
            it.Precio = reg.Precio;
            it.Stock = reg.Stock;
            it.Activo = reg.Activo;

            List<ItemModel> carrito = JsonConvert.DeserializeObject<List<ItemModel>>(HttpContext.Session.GetString("Carrito"));
            carrito?.Add(it);
            HttpContext.Session.SetString("Carrito", JsonConvert.SerializeObject(carrito));
            ViewBag.mensaje = "Producto Agregado";

            return View(reg);
        }

        public ActionResult Carrito()
        {
            if (HttpContext.Session.GetString("Carrito") == null) return RedirectToAction("portal");

            IEnumerable<ItemModel> carrito = JsonConvert.DeserializeObject<List<ItemModel>>(HttpContext.Session.GetString("Carrito"));
            
            return View(carrito);
        }



    }
}
