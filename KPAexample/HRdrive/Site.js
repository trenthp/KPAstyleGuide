function KpaPhoneNumberMask($phoneNumberElement) {
    $phoneNumberElement.inputmask("mask", { "mask": "(999) 999-9999[ x9{1,6}]" });
}