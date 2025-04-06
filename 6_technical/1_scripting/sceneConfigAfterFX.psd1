. "$PSScriptRoot\globalVariables.ps1"

@{
  RenderJobs = @(

    @{ comp = "foo"; start = 0; end = 2; output = "foo.jpeg" }
    @{ comp = "bar"; start = 0; end = 2; output = "bar.jpeg" }
    @{ comp = "production"; start = 0; end = 2; output = "produciton.jpeg" }
  )
}

