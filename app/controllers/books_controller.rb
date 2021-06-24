class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy, :borrow, :returns, :status, :income]
  before_action :set_user, only: [:borrow, :returns]
  skip_before_action :verify_authenticity_token, only: [:borrow, :returns]

  # GET /books or /books.json
  def index
    @books = Book.all
  end

  # GET /books/1 or /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  ##
  # User try to borrow this book
  #
  # POST /books/1/borrow ? user_id = <Target User>
  def borrow
    @book.borrow(@user)
    render json: { object: 'Loan', id: loan.id }, status: :created
  rescue Exceptions::NoBookCopies
    # Not available copies for a new loan:
    render json: { object: 'Book'}, status: :conflict if @book.available == 0
  rescue Exceptions::LowAccountBalance
    # User haven't enougth balance:
    render json: { object: 'User'}, status: :conflict if @user.amount - @book.fee < 0
  end

  ##
  # User gives back this book
  #
  # TODO: Much of the logic must be moved to the model, it's done here by now for easier translate it
  # to error codes. Should be moved to model and exceptions captured and then translated to error codes.
  #
  # POST /books/1/returns ? user_id = <Target User>
  def returns
    @book.returns(@user)
    return render json: { object: 'Loan'}, status: :ok
  rescue Exceptions::InvalidLoan
     render json: { object: 'Loan'}, status: :not_found
  rescue Exceptions::LowAccountBalance
    render json: { object: 'User'}, status: :internal_server_error # Inconsistence found, missing measures, shouldn't happen
  rescue => exception
    Rails.logger.debug exception
    return render json: { object: 'Loan'}, status: :internal_server_error # Missing checks...
  end

  # GET /books/1/status
  def status
  end

  # GET /books/1/income
  def income
    @start_date = params[:start_date]
    @end_date = params[:end_date]
  rescue => exception
    return render json: { 
      errors: exception.full_message(highlight: true, order: :top) 
    }, status: :bad_request
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { object: 'Book'}, status: :not_found
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title, :fee, :count)
    end

    # Define user for book loan's actions
    def set_user
      @user = Account.find_by_user_id(params[:user_id])
      # User not found or not defined:
      render json: { object: 'User'}, status: :not_found if !@user
    end
end
