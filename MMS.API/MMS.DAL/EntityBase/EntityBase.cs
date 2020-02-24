using MMS.Core;
using Newtonsoft.Json;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
    public class EntityBase : IEntityBase
    {
        [NotMapped]
        public ModelState ModelState { get; set; } = ModelState.Unchanged;  

        [JsonIgnore]
        public bool IsAdded => ModelState.Equals(ModelState.Added);

        [JsonIgnore]
        public bool IsModified => ModelState.Equals(ModelState.Modified);

        [JsonIgnore]
        public bool IsDeleted => ModelState.Equals(ModelState.Deleted);

        [JsonIgnore]
        public bool IsUnchanged => ModelState.Equals(ModelState.Unchanged);

        [JsonIgnore]
        public bool IsDetached => ModelState.Equals(ModelState.Detached);
        [JsonIgnore]
        public bool IsArchived => ModelState.Equals(ModelState.Archived);

        public void SetAdded()
        {
            ModelState = ModelState.Added;
        }
        public void SetModified()
        {
            ModelState = ModelState.Modified;
        }
        public void SetDeleted()
        {
            ModelState = IsAdded ? ModelState.Detached : ModelState.Deleted;
        }
        public void SetDetached()
        {
            ModelState = ModelState.Detached;
        }
        public void SetArchived()
        {
            ModelState = IsAdded ? ModelState.Detached : ModelState.Archived;
        }
        public void SetUnchanged()
        {
            ModelState = ModelState.Unchanged;
        }
        public T Copy<T>()
        {
            return (T)MemberwiseClone();
        }
        protected bool PropertyChanged<T>(T oldValue, T newValue)
        {
            if (!oldValue.NotEquals(newValue)) return false;
            if (IsUnchanged) SetModified();
            return true;
        }
        public override string ToString()
        {
            return $"Name = {GetType().Name}, State = {ModelState}";
        }
    }
}
