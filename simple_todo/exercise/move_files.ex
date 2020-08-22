defmodule MoveFile do
  # Ask what kind of file user want to move - Done
  # List all the files that we grab
  # Ask create new folder or use existing folder

  def start do
    prompt = """
      Which file type do you want to move from the current directory?
      options: .jpg .png .gif
    """

    file_type = IO.gets(prompt) |> String.trim() |> String.downcase()

    grab_files(file_type)
    |> insert_to_directory
  end

  def grab_files(type) do
    matches = ~r/\.(#{type})$/
    File.ls!() |> Enum.filter(fn x -> Regex.match?(matches, x) end)
  end

  def insert_to_directory(list_files) do
    number_of_files = Enum.count(list_files)

    text_end =
      case number_of_files do
        1 -> "file"
        _ -> "files"
      end

    directory_name = IO.gets("Enter new directory name\n") |> String.trim()

    case File.mkdir(directory_name) do
      :ok -> IO.puts("Directory created!")
      {:error, _} -> IO.puts("Could not create directory or directory already exists")
    end

    IO.puts(~s{Moving #{number_of_files} #{text_end} :})

    Enum.each(list_files, fn file ->
      case File.rename(file, "#{directory_name}/#{file}") do
        :ok -> IO.puts("#{file} successfully moved")
        {_, _} -> IO.puts("Error moving")
      end
    end)
  end
end
