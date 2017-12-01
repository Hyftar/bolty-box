Directory.destroy_all
Directory.create([
  {
    name: 'test-dir-1',
    public: false,
    user: User.first
  },
  {
    name: 'test-dir-2',
    public: true,
    user: User.second
  },
  {
    name: 'test-dir-3',
    public: false,
    user: User.first,
    users: [User.second]
  }
]
)
Directory.create(
    name: 'test-dir-4',
    public: false,
    user: User.first,
    directory: Directory.first
)
Directory.create(
    name: 'test-dir-5',
    public: public,
    user: User.first,
    directory: Directory.first
)
Directory.create(
    name: 'test-dir-6',
    public: false,
    user: User.second,
    users: [User.first],
    directory: Directory.second
)
