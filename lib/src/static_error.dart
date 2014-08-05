part of static;

/**
 * A generic error that occured within the library.
 */
class StaticError extends Error {
  /**
   * A human-readable error message.
   */
  final String message;
  
  /**
   * An HTTP error status code.
   */
  final int code;
  
  /**
   * A flag which indicates whether this error was generated before or after
   * headers or data were sent over the corresponding request.
   */
  final bool beganSending;
  
  /**
   * A (possibly `null`) error object. If the [StaticError] was caused by an
   * underlying error, this will be it.
   */
  final Object error;
  
  /**
   * Create a [StaticError].
   */
  StaticError(this.code, this.message, this.beganSending, {this.error: null});
  
  /**
   * Convert this [StaticError] to a verbose, human-readable string.
   */
  String toString() {
    return '<StaticError code=$code beganSending=$beganSending' +
        ' message="$message" error=$error>';
  }
}
