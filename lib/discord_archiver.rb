require 'discordrb'

class DiscordArchiver
  @archive_token
  @server_id
  @channel_name
  @channel_group
  @og_channel_group

  def self.setup(archive_token, server_id, channel_name, channel_group, og_channel_group)
    @archive_token = archive_token
    @server_id = server_id
    @channel_name = channel_name
    @channel_group = channel_group
    @og_channel_group = og_channel_group
    self
  end

  def self.start
    puts "-" * 80
    if @archive_token && @server_id && @channel_name && @channel_group && @og_channel_group
      bot = Discordrb::Bot.new token: @archive_token
      bot.run(true)
      puts "Logged in as #{bot.profile.username}."
      check_servers bot.servers

      target_server = bot.servers[@server_id.to_i]

      channels = target_server.channels
      channel = channels.find { |c| c.name == @channel_name }
      parent_channel = channels.find { |c| c.name == @channel_group }

      archive_channel channel, parent_channel
      create_new_channel(target_server)
      bot.stop
    else
      puts "You don't have the proper environment variables set for Discord."
      puts "Add the environment variables and try again."
    end
  end

  def self.check_servers(servers)
    if servers.count == 0
      abort "Bot is not a member of any servers. Please add bot to a server and try again."
    elsif servers.include? @server_id
      abort "Bot is not a member of the specified server. Please add bot to server and try again."
    end
  end

  def self.archive_channel(channel, parent_category)
    puts "Now moving #{@channel_name} to #{@channel_group}."
    channel.name = "#{channel.name}-#{Time.now.strftime("%Y-%m-%d")}"
    channel.category = parent_category.id
    if channel.sync
      puts "#{@channel_name} is now archived"
    else
      puts "There may have been an issue archiving and syncing permissions for #{@channel_name}"
    end
  end

  def self.create_new_channel(server)
    puts "Creating new channel: #{@channel_name}"
    parent = server.channels.find { |channel| channel.name == @og_channel_group }
    server.create_channel(@channel_name, parent: parent)
  end
end
