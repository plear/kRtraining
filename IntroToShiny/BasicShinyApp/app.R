library(shiny)
library(tidyverse)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Midwestern State Demographics"),


    sidebarLayout(
        sidebarPanel(
            selectInput("state", "Select State:", 
                c("Illinois"="IL", 
                    "Indiana"="IN", 
                    "Michigan"="MI", 
                    "Ohio"="OH", 
                    "Wisconsin"="WI"))
        ),


        mainPanel(
            plotOutput("plot", click = "plot_click")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$plot <- renderPlot({
        
        midwest %>% 
            filter(state==input$state) %>% 
            transmute(State = state, 
                White=popwhite,
                Black=popblack,
                `American Indian`=popamerindian,
                Asian=popasian, 
                Other=popother) %>% 
            pivot_longer(!State, names_to = "Demographics", values_to = "Total Population") %>% 
            mutate(`Total Population (000)` = `Total Population`/10**3) %>% 
        ggplot(aes(x=Demographics, y=`Total Population (000)`)) +
            geom_col() + 
            theme_bw()
        
        
    }, res = 96)
    

}

# Run the application 
shinyApp(ui = ui, server = server)
