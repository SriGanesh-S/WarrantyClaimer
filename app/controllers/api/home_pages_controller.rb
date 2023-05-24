class Api::HomePagesController < Api::ApiController
    def index 
        render json:{message:"Welcome To Warranty Claimer"}, status:200
    end
end