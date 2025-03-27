#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("CBA 球员聚类分析结果"),
    br(),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput('team', 'Choose a team: ', choices = c('广东'='GST','山东'='SHA','福建'='FUJ',
                                                               '吉林'='JIL','山西'='SZD','天津'='TIA',
                                                               '新疆'='XIN','浙江稠州'='ZCB','江苏'='JIA',
                                                               '深圳'='DON','辽宁'='LIA','青岛'='QIN',
                                                               '广州'='GFD','上海'='SDS','广厦'='ZGL',
                                                               '北控'='BEIK','八一'='BFT','首钢'='BSD',
                                                               '南京同曦'='TONG','四川'='SICH'
                                                               
                                                               ), selected = 'GST'),
            br(),
            selectInput('season', 'Choose a season: ', choices = 2011:2019, selected = '2011'),
            br(),
            uiOutput('VPlayer'),
        ),

        # Show a plot of the generated distributio
        mainPanel(
            plotly::plotlyOutput('p')
        )
    ),
    fluidRow(
        column(
            width = 12,
            
            dataTableOutput("t")
        )
    )
    
))
