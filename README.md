# Ekohe BMS backend

Backend with API and database for a hypothetical book management system.

* [🚀 **DEMO address** 🌐](https://ekohe-books.herokuapp.com/)

* [📄 **API Docs** 🌐](https://documenter.getpostman.com/view/16352771/TzecDRBX)

## Design

* Main tech stack components

  * PostgreSQL DB.
  * Rails 6 & Ruby 3
  * Hotwired gem (Turbo + StimulusJS)

* Code

  * About the model

    * **`Accounts`:** This one is somehow simplified for the demo. See the note about Users below. 
      * The main info here is the `amount`, where we keep a record of the balance for the user. Can be a user's attribute if we decide to proceed with that implementation, but for now, is an independent entity. 
      * `amount` is set in CRUD operations and decreased at the `pay` operation, which is invoked by the `returns` method of the `Book` model in a transaction.
    * **`Loans`** and **`Books`**: A loan is registered when a copy of a `Book` is borrowed. I use the standard `updated_at` field in combination with a field `active` and the relation of `Loan` with `Book`. Relying completely on this, the whole model is simpler. 
      * Book-count minus count-of-active-loans are the available copies. 
      * The income of a Book between dates is the more complex operation and relies anyway on a query: `book.finished_loans.where(updated_at: start_date..end_date).length *  book.fee`.
      * The Book check for funds before being " borrowed".
    * As can be seen, the independent values to keep updated are reduced to a minimum, and intensively used ActiveRecord relationships and queries to easily infer most of them.
    * All of this is established at the model level, providing consistency; and error conditions elevated to controllers via custom exceptions.

  * Users: *Still work in progress, if you like to be finished or left just tell me.* We can add Devise or similar but can be combined with or substituted for the use of an external 3rd party service for bot authentication and authorization. I've done similar with [Auth0.com](auth0.com) in the past and in current projects I'm working with. With that scenario users, passwords and roles can live on that service and secure Apps and APIs access with a token-based workflow. Login pages live on the security service too.

    > *Btw I created the Auth0 tenant for this demo **[ekohe.us.auth0.com](ekohe.us.auth0.com)**, but require a couple of days to wire it with the backend (and/or frontend too) and it's a little bit outside the original assignment.*

  * Controllers responding to API use standard HTTP response codes to provide standard semantic to every situation. Even with non-error responses.

  * The admin UI is very simple in this case, but as a demonstration, Hotwire enriches, without bloating the app, the possibilities of componentization and auto-AJAX while maintaining the use of server HTML render with the power of Rails helpers and other features. *Pending: Adding simple Google Material components or similar.* 

* The API was documented carefully with Postman. You can even use it as a base for executing the samples. *However, I prefer an approach with Swagger or similar, generating base API doc and cases from tests specifications or similar.* 

* CI process is a must, I have some experience with Github Actions, CircleCI, and others. In this case, the definition was from the Heroku service, instead of Github.