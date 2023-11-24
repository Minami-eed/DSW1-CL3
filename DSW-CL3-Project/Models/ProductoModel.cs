using System.ComponentModel.DataAnnotations;
namespace DSW_CL3_Project.Models
{
    public class ProductoModel
    {
        [Display(Name = "Código")]
        public int IdProducto { get; set; }

        [Display(Name = "Nombre")]
        public string ? Nombre { get; set; }

        [Display(Name = "Descripción")]
        public string ? Descripcion { get; set; }

        [Display(Name = "Marca")]
        public string ? DescripcionMarca { get; set; }

        [Display(Name = "Categoría")]
        public string ? DescripcionCategoria { get; set; }

        [Display(Name = "Precio")]
        public decimal Precio { get; set; }

        [Display(Name = "Stock")]
        public int Stock { get; set; }

        [Display(Name = "Ruta de la Imagen")]
        public string ? RutaImagen { get; set; }

        [Display(Name = "Activo")]
        public bool Activo { get; set; }
    }
}
