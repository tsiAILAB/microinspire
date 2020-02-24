using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
    [Table("Configuration")]
	public class Configuration : Auditable
	{
		[Key]
		public int ConfigId { get; set; }
		[Required]
		public string ConfigType { get; set; }
		[Required]
		public string ConfigName { get; set; }
		
		public string ConfigValue { get; set; }
		
		public string Description { get; set; }
		
		public int? SeqNo { get; set; }
		
		public bool? IsSystemConfig { get; set; }
		
		public bool? IsActive { get; set; }

	}
}