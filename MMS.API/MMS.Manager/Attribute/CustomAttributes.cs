using System;

namespace MMS.Manager
{
    [AttributeUsage(AttributeTargets.Property)]
    public class IgnoreMapAttribute : Attribute
    {
        public IgnoreMapAttribute(bool isIgnore)
        {
            IsIgnore = isIgnore;
        }
        public bool IsIgnore { get; }
    }
}
