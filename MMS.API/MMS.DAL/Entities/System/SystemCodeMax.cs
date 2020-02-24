using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
	[Table("SystemCodeMax")]
	public class SystemCodeMax : EntityBase
	{
		[Key, DatabaseGenerated(DatabaseGeneratedOption.None)]
		public string TableName { get; set; }
		[Key, DatabaseGenerated(DatabaseGeneratedOption.None)]
		public string Period { get; set; }
		
		public int MaxNumber { get; set; }

	}
}