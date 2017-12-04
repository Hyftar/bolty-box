User.destroy_all
Directory.destroy_all

User.create(
  [
    {
      given_name: 'Simon',
      last_name: 'Landry',
      admin: true,
      email: 'test1@example.com',
      password: 'test12345',
      password_confirmation: 'test12345'
    },
    {
      given_name: 'Billy',
      last_name: 'Bouchard',
      admin: false,
      email: 'test2@example.com',
      password: 'test12345',
      password_confirmation: 'test12345'
    },
    {
      given_name: 'Blah',
      last_name: 'Bleh',
      admin: false,
      email: 'test3@example.com',
      password: 'test12345',
      password_confirmation: 'test12345'
    },
    {
      given_name: 'Bleep',
      last_name: 'Bloop',
      admin: false,
      email: 'test4@example.com',
      password: 'test12345',
      password_confirmation: 'test12345'
    }
  ]
)

Directory.create(
  [
    {
      name: 'test-dir-1',
      public: false,
      owner: User.second
    },
    {
      name: 'test-dir-2',
      public: true,
      owner: User.third
    },
    {
      name: 'test-dir-3',
      public: false,
      owner: User.third,
      shared_with: [User.second, User.fourth]
    }
  ]
)

Directory.create(
  name: 'test-dir-4',
  public: false,
  owner: User.second,
  parent: Directory.second
)

Directory.create(
  name: 'test-dir-5',
  public: true,
  owner: User.second,
  parent: Directory.second
)

Directory.create(
  name: 'test-dir-6',
  public: false,
  owner: User.second,
  shared_with: [User.third, User.fourth],
  parent: Directory.third
)

Directory.create(
  name: 'test-dir-7',
  public: true,
  owner: User.fourth,
  parent: Directory.third
)

# Create a file to use as an asset
File.open('db/test/test.txt', 'w') do |f|
  f.puts 'hello world'
end

File.open('db/test/test2.txt', 'w') do |f|
  f.puts 'hello Billy'
end

Asset.create(
  file: File.new("#{Rails.root}/db/test/test.txt"),
  directory: Directory.first
)

Asset.create(
  file: File.new("#{Rails.root}/db/test/test2.txt"),
  directory: Directory.first
)
