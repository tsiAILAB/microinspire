using Microsoft.EntityFrameworkCore;

namespace MMS.DAL
{
    [RepositoryTypes(typeof(IRepository<>), typeof(Repository<,>))]
    public class MMSDbContext : BaseDbContext
    {
        public MMSDbContext(DbContextOptions<MMSDbContext> options) : base(options)
        {
        }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<User>()
               .HasIndex(b => b.Email);
            modelBuilder.Entity<AssignedPartner>()
            .HasKey(c => new { c.UserId, c.PartnerId });
            modelBuilder.Entity<AssignedRole>()
            .HasKey(c => new { c.UserId, c.Role });
        }
        public virtual DbSet<User> Users { get; set; }
        public virtual DbSet<AgentUser> AgentUsers { get; set; }
        public virtual DbSet<UserLogTracker> UserLogTrackers { get; set; }
        public virtual DbSet<RecordHistory> RecordHistories { get; set; }

        public virtual DbSet<Configuration> Configurations { get; set; }
        public virtual DbSet<Country> Countries { get; set; }
        public virtual DbSet<Partner> Partners { get; set; }
        public virtual DbSet<Product> Products { get; set; }
        public virtual DbSet<Benefit> Benefits { get; set; }
        public virtual DbSet<ProductBenefit> ProductBenefits { get; set; }
        public virtual DbSet<ProductConfig> ProductConfigs { get; set; }

        public virtual DbSet<Policy> Policies { get; set; }
        public virtual DbSet<PolicyAsset> PolicyAssets { get; set; }
        public virtual DbSet<Client> Clients { get; set; }
        public virtual DbSet<PolicyClient> PolicyClients { get; set; }
        public virtual DbSet<PolicyNote> PolicyNotes { get; set; }
        public virtual DbSet<Claim> Claims { get; set; }
        public virtual DbSet<ClaimIncident> ClaimIncidents { get; set; }
        public virtual DbSet<ClaimDocument> ClaimDocuments { get; set; }
        public virtual DbSet<ClaimNote> ClaimNotes { get; set; }
        public virtual DbSet<ClaimPayment> ClaimPayments { get; set; }
        public virtual DbSet<LineOfBusiness> LineOfBusiness { get; set; }
        public virtual DbSet<ProductBusiness> ProductBusiness { get; set; }
        public virtual DbSet<UnderWriter> UnderWriters { get; set; }
        public virtual DbSet<AssignedPartner> AssignedPartners { get; set; }
        public virtual DbSet<AssignedRole> AssignedRoles { get; set; }

        public virtual DbSet<NirvoyClient> NirvoyClients { get; set; }

    }
}
