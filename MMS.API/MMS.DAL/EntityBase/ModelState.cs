using System;

namespace MMS.DAL
{
    // Summary:
    //     Gets the state of a model object.
    [Flags]
    public enum ModelState
    {
        Added = 1,
        Modified = 2,
        Deleted = 3,
        Unchanged = 4,
        Detached = 5,
        Archived = 6
    }
}
