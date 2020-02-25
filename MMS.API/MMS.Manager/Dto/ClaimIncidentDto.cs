using Core;
using MMS.DAL;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;

namespace MMS.Manager
{
    [AutoMap(typeof(ClaimIncident)), Serializable]
    public class ClaimIncidentDto : Auditable
    {

        private int incidentId;
        public int IncidentId
        {
            get
            {
                return incidentId;
            }
            set
            {
                if (PropertyChanged(incidentId, value))
                    incidentId = value;
            }
        }

        private int claimId;
        public int ClaimId
        {
            get
            {
                return claimId;
            }
            set
            {
                if (PropertyChanged(claimId, value))
                    claimId = value;
            }
        }

        private DateTime dateOfDeath;
        [JsonConverter(typeof(DateConverter))]
        public DateTime DateOfDeath
        {
            get
            {
                return dateOfDeath;
            }
            set
            {
                if (PropertyChanged(dateOfDeath, value))
                    dateOfDeath = value;
            }
        }

        private string locationOfIncident;
        public string LocationOfIncident
        {
            get
            {
                return locationOfIncident;
            }
            set
            {
                if (PropertyChanged(locationOfIncident, value))
                    locationOfIncident = value;
            }
        }

        private string incidentType;
        public string IncidentType
        {
            get
            {
                return incidentType;
            }
            set
            {
                if (PropertyChanged(incidentType, value))
                    incidentType = value;
            }
        }

        private int? daysFromIncident;
        public int? DaysFromIncident
        {
            get
            {
                return daysFromIncident;
            }
            set
            {
                if (PropertyChanged(daysFromIncident, value))
                    daysFromIncident = value;
            }
        }

        private string hospitalName;
        public string HospitalName
        {
            get
            {
                return hospitalName;
            }
            set
            {
                if (PropertyChanged(hospitalName, value))
                    hospitalName = value;
            }
        }

        private string hospitalWard;
        public string HospitalWard
        {
            get
            {
                return hospitalWard;
            }
            set
            {
                if (PropertyChanged(hospitalWard, value))
                    hospitalWard = value;
            }
        }

        private string hospitalLocation;
        public string HospitalLocation
        {
            get
            {
                return hospitalLocation;
            }
            set
            {
                if (PropertyChanged(hospitalLocation, value))
                    hospitalLocation = value;
            }
        }

        private string causeOfIncident;
        public string CauseOfIncident
        {
            get
            {
                return causeOfIncident;
            }
            set
            {
                if (PropertyChanged(causeOfIncident, value))
                    causeOfIncident = value;
            }
        }

        private string note;
        public string Note
        {
            get
            {
                return note;
            }
            set
            {
                if (PropertyChanged(note, value))
                    note = value;
            }
        }

        public List<string> CauseOfIncidents { get; set; }

    }
}