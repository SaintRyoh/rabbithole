<h1>Rabbithole Style Guide</h1>

This style guide represents the coding conventions for the Rabbithole project. It is based on the Lua style guidelines with specific adaptations to our project. All contributors are strongly encouraged to follow these guidelines to maintain a consistent and clean codebase.
Naming Conventions

<h2>Classes: Class names should use PascalCase.</h2>

    lua

    local ExampleClass = {}
    ExampleClass.__index = ExampleClass

<h3>Class Functions: Functions of a class should be written in camelCase. Use colon (:) for defining functions.</h3>

    lua

    function ExampleClass:exampleFunction()
        -- function body
    end

<h2>Local Variables: Names should follow lower_case convention.</h2>

    lua

    local lower_case_variable = "value"

<h2>Booleans: Boolean variables should be prefixed with is_, for example is_directory.</h2>

    lua

    local is_directory = true

<h2>Global Variables: Global variables should be in UPPER_CASE. Their usage is discouraged due to potential global namespace pollution. Use local variables whenever possible.</h2>

    lua

    local this_is_local = true
    GLOBAL_CONST = false

<h2>Modules: Standalone modules should be written in kebab-case, and sub-modules should be in camelCase. Each module should contain an init.lua file which returns the module.</h2>

    lua

    -- /example-module/init.lua
    local exampleModule = {}

    -- /example-module/camelCaseSubModule.lua
    local camelCaseSubModule = {}

<h2>capi Tables: Use these to localize "common application programming interface" variables.</h2>

    lua

    local capi = {
        screen = screen,
        client = client,
        awesome = awesome
    }

<h2>Spacing and Formatting</h2>

Use four (4) spaces for indentation.

Maintain consistent spacing around operators.

    lua

    local x = y + z

<h2>Leave a space inside the braces when creating empty tables.</h2>

    lua

    local t = {}

<h2>Use the following format for dictionary style tables.</h2>

    lua

    naughty.notify({
        title = "Error saving session",
        text = err,
        timeout = 0
    })

<h2>Property and Function Definitions</h2>

Use dot (.) notation to define class properties and variables.

    lua

    function ExampleClass.new(self)
        self.example_property = "value"
    end

Use colon (:) notation to define class functions.

    lua

    function ExampleClass:exampleFunction()
        -- function body
    end

Functional Programming

Prefer functional programming style where it does not cause a performance decrease.

Utilize the lodash library, required as __ 

    Example:
    __.first
    __.isEmpty

for functional programming operations.

<h2>Comments</h2>

Use spaces after comment syntax, including in-line comments.

    lua

    local var = nil -- This is a proper comment

Use the following multi-line comment syntax for multiple lines.

    lua

    --[[ This is a multi-line
    comment.
    ]]

For functions requiring complex comments, provide clear and concise information, including function purpose, parameters, and usage examples.

    lua

    --[[ 
    chromaticTesseract takes a color as a string or RGB value, a color theory scheme,
    and options as arguments and returns a theme table that can be used with beautiful.init().

    Usage example:
    local primary_color = "#4CAF50" -- Material Design Green 500
    local color_scheme = "complementary" -- You can choose from the schemes listed above
    local options = {
        saturation_range = 0.1,
        lightness_range = 0.1,
        font = "Roboto 12",
        fg_normal = "#FFFFFF",
        fg_focus = "#000000",
        extra_roles = {
            urgent = "color3",
            minimize = "color4"
        }
    }
    ]]

<h3>Conclusion</h3>

Aim for code clarity and consistency when contributing to the Rabbithole project. This guide should serve as a reference for achieving a clean and understandable codebase. We appreciate your adherence to these standards.
