// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Vakıf Atlas Management';

  @override
  String get appBrandSubtitle => 'VGM Management Console';

  @override
  String get errorInvalidRequest =>
      'The request is invalid. Please check the information you entered.';

  @override
  String get errorNotFound =>
      'The record was not found or you are not authorised for this action.';

  @override
  String get errorServerUnavailable =>
      'The server is temporarily unavailable. Please try again shortly.';

  @override
  String get errorUnexpected =>
      'An unexpected error occurred. Please try again.';

  @override
  String get errorUnauthorized =>
      'Your session has expired or you are not authorised for this action.';

  @override
  String get errorTooManyRequests =>
      'Too many attempts. Please try again later.';

  @override
  String errorTooManyRequestsRetry(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Too many attempts. Try again in $minutes minutes.',
      one: 'Too many attempts. Try again in 1 minute.',
    );
    return '$_temp0';
  }

  @override
  String get errorOffline =>
      'You are offline. Check your connection and try again.';

  @override
  String get errorServerUnreachable =>
      'The Vakıf Atlas server cannot be reached right now. Your internet connection works; please try again shortly.';

  @override
  String get errorCacheRead => 'Local data could not be read.';

  @override
  String get errorSecurityViolation =>
      'The secure connection could not be verified.';

  @override
  String get errorInvalidCredentials =>
      'The email address or password is incorrect. Check your details and try again.';

  @override
  String get errorInvalidMfaCode =>
      'The verification code is incorrect. Enter the current code from your authenticator app.';

  @override
  String get errorMfaExpired =>
      'The sign-in step has expired. Please sign in again.';

  @override
  String get errorInvalidVerificationCode =>
      'The code is incorrect. Check the 6-digit code in your email and try again.';

  @override
  String get errorVerificationCodeExpired =>
      'The code has expired or there were too many failed attempts. Request a new code.';

  @override
  String get errorWeakPassword =>
      'This password does not meet the security rules. Choose a longer password that is hard to guess.';

  @override
  String get errorInvalidCurrentPassword =>
      'Your current password is incorrect.';

  @override
  String get errorStaleData =>
      'This record was changed by another staff member while you were reviewing it. Reload the latest version and try again.';

  @override
  String get errorConflictTransition =>
      'This status change is no longer valid. Refresh the record.';

  @override
  String get errorConflictMonumentExists =>
      'A monument with this ID already exists. Choose a different ID.';

  @override
  String get errorConflictComplexMembers =>
      'This breaks the complex rules: a complex with buildings cannot be removed and buildings cannot be complexes.';

  @override
  String get errorConflictLastAdmin =>
      'At least one active administrator must remain.';

  @override
  String get errorConflictSelf =>
      'You cannot remove your own administrator role or disable yourself.';

  @override
  String get errorConflictInProgress =>
      'The same request is still being processed. Try again in a few seconds.';

  @override
  String get errorConflictStaffExists =>
      'This email address is already registered as staff.';

  @override
  String badgeOverflow(int max) {
    return '$max+';
  }

  @override
  String buttonLoadingSemantics(String label) {
    return '$label, loading';
  }

  @override
  String get passwordShow => 'Show password';

  @override
  String get passwordHide => 'Hide password';

  @override
  String get a11yImageHidden => 'Image hidden';

  @override
  String get galleryImageError => 'The image could not be loaded';

  @override
  String get notFoundTitle => 'Page not found';

  @override
  String get notFoundBody =>
      'The page you are looking for may have been moved or removed.';

  @override
  String get notFoundAction => 'Back to dashboard';

  @override
  String get featurePendingHeading => 'Coming soon';

  @override
  String featurePendingBody(String feature) {
    return '$feature will be available in a later release.';
  }

  @override
  String get offlineBannerMessage =>
      'You are offline. Changes cannot be saved until you are back online.';

  @override
  String get offlineAnnouncement => 'Internet connection lost';

  @override
  String get onlineAnnouncement => 'Internet connection restored';

  @override
  String get privacyOverlaySemantics =>
      'Vakıf Atlas Management, content hidden';

  @override
  String get splashLoadingSemantics => 'Vakıf Atlas Management is starting';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonClose => 'Close';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonReload => 'Reload';

  @override
  String get commonLoading => 'Loading';

  @override
  String get commonLoadMore => 'Load more';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonClearFilters => 'Clear filters';

  @override
  String get commonAll => 'All';

  @override
  String get commonBack => 'Back';

  @override
  String get commonCopy => 'Copy';

  @override
  String get commonCopied => 'Copied to clipboard';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonNone => '—';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String commonResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results',
      one: '1 result',
      zero: 'No results',
    );
    return '$_temp0';
  }

  @override
  String commonShownOfTotal(int shown, int total) {
    return 'Showing $shown of $total';
  }

  @override
  String get commonEmptyTitle => 'Nothing here';

  @override
  String get commonEmptyFiltered => 'No records match the selected filters.';

  @override
  String get commonLoadError => 'Data could not be loaded';

  @override
  String get commonSelectPrompt =>
      'Select a record from the list to see its details.';

  @override
  String get commonUnsavedTitle => 'Unsaved changes';

  @override
  String get commonUnsavedBody =>
      'Your changes will be lost. Do you want to leave?';

  @override
  String get commonDiscard => 'Discard changes';

  @override
  String get commonStaleTitle => 'Record changed';

  @override
  String get searchClear => 'Clear search';

  @override
  String get navLabel => 'Main navigation';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navCatalog => 'Catalog';

  @override
  String get navCivilProtection => 'Civil Protection';

  @override
  String get navModeration => 'Memory Moderation';

  @override
  String get navFeedback => 'Feedback';

  @override
  String get navStaff => 'Staff';

  @override
  String get navAudit => 'Audit Log';

  @override
  String get navProfile => 'My profile';

  @override
  String get navSettings => 'Settings';

  @override
  String get navSignOut => 'Sign out';

  @override
  String get navCollapse => 'Collapse sidebar';

  @override
  String get navExpand => 'Expand sidebar';

  @override
  String navAccountMenu(String name) {
    return 'Account menu, $name';
  }

  @override
  String navBadgeSemantics(String label, int count) {
    return '$label, $count pending';
  }

  @override
  String get roleAdmin => 'Administrator';

  @override
  String get signOutConfirmTitle => 'Sign out?';

  @override
  String get signOutConfirmBody =>
      'Your staff session on this device will be closed.';

  @override
  String get sessionExpiredMessage =>
      'Your session has ended. Please sign in again.';

  @override
  String get sessionIdleMessage =>
      'Your session was closed for security after 24 hours of inactivity.';

  @override
  String get signInTitle => 'Staff sign-in';

  @override
  String get signInSubtitle =>
      'Management console for VGM staff. Access depends on your role.';

  @override
  String get signInEmail => 'Work email';

  @override
  String get signInPassword => 'Password';

  @override
  String get signInSubmit => 'Continue';

  @override
  String get signInForgotPassword => 'Forgot password';

  @override
  String get signInEmailInvalid => 'Enter a valid email address.';

  @override
  String get signInPasswordRequired => 'Enter your password.';

  @override
  String get signInMfaTitle => 'Two-step verification';

  @override
  String get signInMfaBody =>
      'Enter the 6-digit code from your authenticator app.';

  @override
  String get signInMfaCode => 'Verification code';

  @override
  String get signInMfaCodeInvalid => 'Enter the 6-digit code.';

  @override
  String get signInMfaVerify => 'Verify and sign in';

  @override
  String get signInUseRecovery => 'Use a recovery code';

  @override
  String get signInUseAuthenticator => 'Use an authenticator code';

  @override
  String get signInRecoveryCode => 'Recovery code';

  @override
  String get signInRecoveryHint => 'XXXX-XXXX';

  @override
  String get signInRecoveryInvalid =>
      'A recovery code has 8 characters (XXXX-XXXX).';

  @override
  String get signInBack => 'Sign in with a different account';

  @override
  String signInExpiresIn(int minutes) {
    return 'This step is valid for $minutes minutes.';
  }

  @override
  String get enrollTitle => 'Set up your authenticator';

  @override
  String get enrollBody =>
      'Administrator accounts require two-step verification. Scan the QR code with an app such as Google Authenticator or Microsoft Authenticator, or enter the setup key manually.';

  @override
  String get enrollQrSemantics =>
      'Authenticator setup QR code. If you cannot scan it, use the setup key below.';

  @override
  String get enrollSecretLabel => 'Setup key';

  @override
  String enrollAccount(String account) {
    return 'Account: $account';
  }

  @override
  String get enrollConfirmCode => 'Code shown in the app';

  @override
  String get enrollConfirm => 'Complete setup';

  @override
  String get recoveryTitle => 'Your recovery codes';

  @override
  String get recoveryBody =>
      'If you lose access to your authenticator app you can sign in with one of these codes. Each code works once. Store them somewhere safe; they will not be shown again.';

  @override
  String get recoveryCopyAll => 'Copy all';

  @override
  String get recoveryAcknowledge => 'I have saved the codes somewhere safe';

  @override
  String get recoveryContinue => 'Go to the console';

  @override
  String get resetTitle => 'Set or reset password';

  @override
  String get resetBody =>
      'Enter your work email. If you have an account we will send a 6-digit code.';

  @override
  String get resetSendCode => 'Send code';

  @override
  String get resetCodeSent =>
      'Code sent. Enter the code from your email and your new password.';

  @override
  String get resetCode => 'Code from email';

  @override
  String get resetNewPassword => 'New password';

  @override
  String get resetPasswordHint =>
      'At least 12 characters. A long passphrase is the safest.';

  @override
  String get resetPasswordTooShort =>
      'The password must be at least 12 characters.';

  @override
  String get resetSubmit => 'Save password';

  @override
  String get resetDone => 'Your password has been saved. You can sign in now.';

  @override
  String get resetBackToSignIn => 'Back to sign-in';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String dashboardGreeting(String name) {
    return 'Welcome, $name';
  }

  @override
  String dashboardUpdatedAt(String time) {
    return 'Last updated: $time';
  }

  @override
  String get dashboardRefresh => 'Refresh';

  @override
  String get dashboardSectionError =>
      'The summary for this section could not be loaded.';

  @override
  String get dashboardReportsTitle => 'Civil Protection reports';

  @override
  String dashboardReportsCritical(int count) {
    return '$count critical';
  }

  @override
  String get dashboardModerationTitle => 'Memory Corner moderation';

  @override
  String dashboardModerationPending(int count) {
    return '$count awaiting approval';
  }

  @override
  String dashboardModerationReported(int count) {
    return '$count reported memories';
  }

  @override
  String get dashboardFeedbackTitle => 'Feedback';

  @override
  String dashboardFeedbackRating(String rating, int count) {
    return 'Average rating $rating ($count ratings)';
  }

  @override
  String get dashboardFeedbackNoRating => 'No ratings yet';

  @override
  String get dashboardCatalogTitle => 'Catalog';

  @override
  String dashboardCatalogArchived(int count) {
    return '$count unpublished';
  }

  @override
  String get dashboardNoSections =>
      'Your role does not open any management section yet. Ask your VGM administrator for access.';

  @override
  String get reportsTitle => 'Civil Protection review';

  @override
  String get reportsSubtitle =>
      'Damage reports submitted by citizens. Status changes are shown to the citizen together with your note.';

  @override
  String get reportsSearch => 'Reference code (SK-2026-…)';

  @override
  String get reportsListLabel => 'Report queue';

  @override
  String get reportsDetailLabel => 'Report details';

  @override
  String get reportsFilterStatus => 'Status';

  @override
  String get reportsFilterUrgency => 'Urgency';

  @override
  String get reportsFilterCategory => 'Damage type';

  @override
  String get reportsFilterOpen => 'Open';

  @override
  String get reportsSort => 'Sort';

  @override
  String get reportsSortNewest => 'Newest';

  @override
  String get reportsSortOldest => 'Oldest';

  @override
  String get reportsSortUrgency => 'By urgency';

  @override
  String get reportsEmpty => 'No reports match these filters.';

  @override
  String get reportStatusReceived => 'Received';

  @override
  String get reportStatusInReview => 'In review';

  @override
  String get reportStatusForwarded => 'Forwarded';

  @override
  String get reportStatusResolved => 'Resolved';

  @override
  String get reportStatusClosed => 'Closed';

  @override
  String get urgencyCritical => 'Critical';

  @override
  String get urgencyHigh => 'High';

  @override
  String get urgencyMedium => 'Medium';

  @override
  String get urgencyLow => 'Low';

  @override
  String urgencyLabel(String level) {
    return 'Urgency: $level';
  }

  @override
  String get categoryStructuralDamage => 'Structural damage';

  @override
  String get categoryCollapseRisk => 'Collapse risk';

  @override
  String get categoryVandalism => 'Vandalism';

  @override
  String get categoryTheft => 'Theft';

  @override
  String get categoryFireOrWater => 'Fire / water damage';

  @override
  String get categoryUnauthorizedWork => 'Unauthorised work';

  @override
  String get categoryOther => 'Other';

  @override
  String get verificationNotProvided => 'Location not shared';

  @override
  String verificationOnSite(int distance) {
    return 'On site ($distance m from the monument)';
  }

  @override
  String verificationDistant(int distance) {
    return 'Away ($distance m from the monument)';
  }

  @override
  String get reportSectionSummary => 'Report';

  @override
  String get reportSectionPhotos => 'Photos';

  @override
  String get reportSectionLocation => 'Location';

  @override
  String get reportSectionHistory => 'Timeline';

  @override
  String get reportSectionAction => 'Update status';

  @override
  String get reportMonument => 'Monument';

  @override
  String get reportPlace => 'Place';

  @override
  String get reportCategory => 'Damage type';

  @override
  String get reportCreatedAt => 'Reported on';

  @override
  String get reportReference => 'Reference code';

  @override
  String get reportAnonymized =>
      'The reporter deleted their account; the record is kept without a link to the person.';

  @override
  String get reportNoPhotos => 'No photos attached.';

  @override
  String reportPhotoSemantics(int index, int count) {
    return 'Report photo $index of $count';
  }

  @override
  String reportCoordinates(String latitude, String longitude, int accuracy) {
    return '$latitude, $longitude (±$accuracy m)';
  }

  @override
  String get reportCopyCoordinates => 'Copy coordinates';

  @override
  String get reportOpenMap => 'Open in OpenStreetMap';

  @override
  String get reportLocationRetention =>
      'The raw location is only for VGM review; it is deleted 90 days after the report is closed.';

  @override
  String reportHistoryBy(String name) {
    return 'by $name';
  }

  @override
  String reportHistoryNoteCitizen(String note) {
    return 'Note to citizen: $note';
  }

  @override
  String reportHistoryNoteInternal(String note) {
    return 'Internal note: $note';
  }

  @override
  String get reportFinalStatus =>
      'This report is closed; its status can no longer change.';

  @override
  String get reportNextStatus => 'New status';

  @override
  String get reportNoteCitizen => 'Note to the citizen (optional)';

  @override
  String get reportNoteCitizenHelp =>
      'Shown on the citizen\'s reports screen. Do not include personal data.';

  @override
  String get reportNoteInternal => 'Internal note (staff only)';

  @override
  String get reportNoteTooLong => 'A note can be at most 1000 characters.';

  @override
  String get reportUpdate => 'Update status';

  @override
  String reportUpdated(String status) {
    return 'Report status updated: $status';
  }

  @override
  String get reportConfirmFinalTitle => 'Close this report?';

  @override
  String reportConfirmFinalBody(String status) {
    return '\"$status\" is a final status; it cannot be changed later and the raw location retention period starts.';
  }

  @override
  String reportTileSemantics(
    String reference,
    String monument,
    String status,
    String urgency,
  ) {
    return '$reference, $monument, $status, urgency $urgency';
  }

  @override
  String get moderationTitle => 'Memory Corner moderation';

  @override
  String get moderationSubtitle =>
      'Memories awaiting approval and user reports (complaints). A memory reported by 3 different people is hidden from everyone until reviewed.';

  @override
  String get moderationSearch => 'Search text or author';

  @override
  String get moderationListLabel => 'Moderation queue';

  @override
  String get moderationDetailLabel => 'Memory details';

  @override
  String get moderationQueuePending => 'Awaiting approval';

  @override
  String get moderationQueueReported => 'Reported';

  @override
  String get moderationQueueRejected => 'Removed';

  @override
  String get moderationQueueAll => 'All';

  @override
  String get moderationEmptyPending => 'No memories are awaiting approval.';

  @override
  String get moderationEmptyReported => 'No memories with open reports.';

  @override
  String get memoryStatusApproved => 'Published';

  @override
  String get memoryStatusPending => 'Awaiting approval';

  @override
  String get memoryStatusRejected => 'Removed';

  @override
  String get memoryHiddenByReports => 'Hidden by reports';

  @override
  String memoryOpenReports(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count open reports',
      one: '1 open report',
    );
    return '$_temp0';
  }

  @override
  String get reasonOffensive => 'Offensive';

  @override
  String get reasonInappropriate => 'Inappropriate';

  @override
  String get reasonSpam => 'Spam / advertising';

  @override
  String get reasonPersonalInfo => 'Contains personal information';

  @override
  String get reasonUnrelated => 'Unrelated to the monument';

  @override
  String get reasonOther => 'Other';

  @override
  String memoryTileSemantics(String monument, String author, String status) {
    return '$monument, $author, $status';
  }

  @override
  String get memorySectionContent => 'Memory';

  @override
  String get memorySectionReports => 'Reports';

  @override
  String get memorySectionModeration => 'Moderation decision';

  @override
  String get memoryAuthor => 'Author';

  @override
  String get memoryMonument => 'Monument';

  @override
  String get memoryDate => 'Memory date';

  @override
  String get memorySharedAt => 'Shared';

  @override
  String get memoryNoReports => 'No reports for this memory.';

  @override
  String get memoryReportResolutionOpen => 'Open';

  @override
  String get memoryReportResolutionUpheld => 'Upheld';

  @override
  String get memoryReportResolutionDismissed => 'Dismissed';

  @override
  String memoryLastDecision(String name, String date) {
    return 'Last decision: $name, $date';
  }

  @override
  String memoryPhotoSemantics(int index, int count) {
    return 'Memory photo $index of $count';
  }

  @override
  String get decisionApprove => 'Publish';

  @override
  String get decisionKeep => 'Dismiss reports, keep published';

  @override
  String get decisionRestore => 'Restore';

  @override
  String get decisionReject => 'Remove';

  @override
  String get decisionReason => 'Reason for removal';

  @override
  String get decisionReasonRequired => 'Choose a reason for removal.';

  @override
  String get decisionNote =>
      'Internal note (optional, not shown to the author)';

  @override
  String get decisionRejectConfirmTitle => 'Remove this memory?';

  @override
  String get decisionRejectConfirmBody =>
      'The memory is hidden from everyone and open reports are upheld. You can change this later by restoring it.';

  @override
  String decisionSaved(String status) {
    return 'Moderation decision saved: $status';
  }

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackSubtitle =>
      'Suggestions, bug reports and accessibility feedback from the citizen app.';

  @override
  String get feedbackSearch => 'Search messages';

  @override
  String get feedbackListLabel => 'Feedback list';

  @override
  String get feedbackDetailLabel => 'Feedback details';

  @override
  String get feedbackFilterStatus => 'Status';

  @override
  String get feedbackFilterCategory => 'Topic';

  @override
  String get feedbackFilterRating => 'Rating';

  @override
  String get feedbackNoRating => 'No rating';

  @override
  String get feedbackStatusNew => 'New';

  @override
  String get feedbackStatusInProgress => 'In progress';

  @override
  String get feedbackStatusDone => 'Done';

  @override
  String get feedbackStatusDismissed => 'Dismissed';

  @override
  String get feedbackCategorySuggestion => 'Suggestion';

  @override
  String get feedbackCategoryBug => 'Bug';

  @override
  String get feedbackCategoryAccessibility => 'Accessibility';

  @override
  String get feedbackCategoryContent => 'Monument content';

  @override
  String get feedbackCategoryOther => 'Other';

  @override
  String feedbackRatingValue(int rating) {
    return '$rating of 5 stars';
  }

  @override
  String get feedbackEmptyMessage => '(Rating only)';

  @override
  String get feedbackSectionMessage => 'Message';

  @override
  String get feedbackSectionContext => 'Context';

  @override
  String get feedbackSectionTriage => 'Triage';

  @override
  String get feedbackAppVersion => 'App version';

  @override
  String get feedbackPlatform => 'Platform';

  @override
  String get feedbackLanguage => 'Language';

  @override
  String get feedbackSender => 'Sender';

  @override
  String get feedbackFromAccount => 'Signed-in account';

  @override
  String get feedbackFromGuest => 'Guest';

  @override
  String get feedbackReceivedAt => 'Received';

  @override
  String feedbackHandledBy(String name, String date) {
    return 'Last handled: $name, $date';
  }

  @override
  String get feedbackStaffNote => 'Internal note (not shown to the sender)';

  @override
  String get feedbackSaveTriage => 'Save';

  @override
  String feedbackTriaged(String status) {
    return 'Feedback status: $status';
  }

  @override
  String feedbackTileSemantics(String category, String status, String date) {
    return '$category, $status, $date';
  }

  @override
  String get staffTitle => 'Staff';

  @override
  String get staffSubtitle =>
      'VGM staff with access to the console and their roles. Each role opens only its own section.';

  @override
  String get staffSearch => 'Search name or email';

  @override
  String get staffListLabel => 'Staff list';

  @override
  String get staffDetailLabel => 'Staff details';

  @override
  String get staffFilterRole => 'Role';

  @override
  String get staffFilterStatus => 'Status';

  @override
  String get staffStatusActive => 'Active';

  @override
  String get staffStatusDisabled => 'Disabled';

  @override
  String get staffInvite => 'Invite staff';

  @override
  String get staffInviteTitle => 'Invite staff member';

  @override
  String get staffInviteBody =>
      'The person receives an email; they set their password with \"Forgot password\" and set up an authenticator on first sign-in.';

  @override
  String get staffInviteName => 'Full name';

  @override
  String get staffInviteNameRequired => 'Enter the full name.';

  @override
  String get staffInviteRolesRequired => 'Choose at least one role.';

  @override
  String get staffInviteSend => 'Send invitation';

  @override
  String staffInvited(String name) {
    return '$name has been invited';
  }

  @override
  String get staffRoles => 'Roles';

  @override
  String get staffRolesSave => 'Save roles';

  @override
  String get staffRolesSaved =>
      'Roles saved; the staff member\'s open sessions were ended.';

  @override
  String get staffSectionAccount => 'Account';

  @override
  String get staffSectionSecurity => 'Security';

  @override
  String staffMfaEnrolled(String date) {
    return 'Two-step verification set up ($date)';
  }

  @override
  String get staffMfaNotEnrolled =>
      'Two-step verification not set up yet (set up on first sign-in)';

  @override
  String get staffLastLogin => 'Last sign-in';

  @override
  String get staffNever => 'Never signed in';

  @override
  String get staffCreatedAt => 'Added';

  @override
  String get staffYou => 'You';

  @override
  String get staffDisable => 'Disable access';

  @override
  String get staffEnable => 'Enable access';

  @override
  String get staffDisableConfirmTitle => 'Disable staff access?';

  @override
  String get staffDisableConfirmBody =>
      'The person can no longer sign in to the console and open sessions end immediately. Their citizen account is not affected.';

  @override
  String get staffResetMfa => 'Reset authenticator';

  @override
  String get staffResetMfaConfirmTitle => 'Reset the authenticator?';

  @override
  String get staffResetMfaConfirmBody =>
      'Recovery codes become invalid and the person sets up two-step verification again at next sign-in. Do this only after verifying their identity through another channel.';

  @override
  String get staffRevokeSessions => 'End sessions';

  @override
  String get staffRevokeConfirmTitle => 'End all sessions?';

  @override
  String get staffRevokeConfirmBody =>
      'The person\'s open console sessions are closed; they must sign in again.';

  @override
  String get staffActionDone => 'Done';

  @override
  String get staffSelfNote =>
      'Removing roles from and disabling your own account is not allowed.';

  @override
  String staffTileSemantics(String name, String roles, String status) {
    return '$name, $roles, $status';
  }

  @override
  String get auditTitle => 'Audit log';

  @override
  String get auditSubtitle =>
      'Staff actions across all services: who changed what, when and on which record.';

  @override
  String get auditFilterService => 'Service';

  @override
  String get auditTargetSearch => 'Record ID';

  @override
  String get auditDateRange => 'Date range';

  @override
  String get auditColumnTime => 'Time';

  @override
  String get auditColumnActor => 'Staff';

  @override
  String get auditColumnAction => 'Action';

  @override
  String get auditColumnTarget => 'Record';

  @override
  String get auditChanges => 'Changes';

  @override
  String auditCorrelation(String id) {
    return 'Trace ID: $id';
  }

  @override
  String get auditNoChanges => 'No further details';

  @override
  String get auditServiceIdentity => 'Identity';

  @override
  String get auditServiceCatalog => 'Catalog';

  @override
  String get auditServiceCivilProtection => 'Civil Protection';

  @override
  String get auditServiceMemories => 'Memory Corner';

  @override
  String get auditServiceFeedback => 'Feedback';

  @override
  String get auditActionSignedIn => 'Signed in to the console';

  @override
  String get auditActionMfaEnrolled => 'Set up two-step verification';

  @override
  String get auditActionRecoveryUsed => 'Used a recovery code';

  @override
  String get auditActionRecoveryRegenerated => 'Regenerated recovery codes';

  @override
  String get auditActionPasswordChanged => 'Changed their password';

  @override
  String get auditActionStaffInvited => 'Invited a staff member';

  @override
  String get auditActionStaffRoles => 'Changed staff roles';

  @override
  String get auditActionStaffDisabled => 'Disabled staff access';

  @override
  String get auditActionStaffEnabled => 'Enabled staff access';

  @override
  String get auditActionStaffMfaReset => 'Reset an authenticator';

  @override
  String get auditActionStaffSessions => 'Ended sessions';

  @override
  String get auditActionReportStatus => 'Changed a report status';

  @override
  String get auditActionMemoryApproved => 'Approved or kept a memory';

  @override
  String get auditActionMemoryRejected => 'Removed a memory';

  @override
  String get auditActionFeedbackTriaged => 'Triaged feedback';

  @override
  String get auditActionMonumentCreated => 'Added a monument';

  @override
  String get auditActionMonumentUpdated => 'Updated a monument';

  @override
  String get auditActionMonumentArchived => 'Unpublished a monument';

  @override
  String get auditActionMonumentRestored => 'Republished a monument';

  @override
  String get auditActionComplexMembers => 'Edited complex buildings';

  @override
  String get profileTitle => 'My profile';

  @override
  String get profileSectionAccount => 'Account';

  @override
  String get profileSectionRoles => 'My roles';

  @override
  String get profileSectionSecurity => 'Security';

  @override
  String get profileSectionPassword => 'Change password';

  @override
  String get profileRolesHelp => 'Roles are assigned by a VGM administrator.';

  @override
  String profileMfaOn(String date) {
    return 'Two-step verification on (set up $date)';
  }

  @override
  String profileRecoveryRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recovery codes left.',
      one: '1 recovery code left.',
      zero: 'No recovery codes left.',
    );
    return '$_temp0';
  }

  @override
  String get profileRecoveryLow =>
      'You are running low on recovery codes. Regenerate them before you lose access to your authenticator.';

  @override
  String get profileRegenerate => 'Regenerate recovery codes';

  @override
  String get profileRegenerateTitle => 'Regenerate recovery codes';

  @override
  String get profileRegenerateBody =>
      'Old codes stop working. Enter the current code from your authenticator app to confirm.';

  @override
  String get profileRegenerateConfirm => 'Regenerate';

  @override
  String get profileCurrentPassword => 'Current password';

  @override
  String get profilePasswordSaved =>
      'Your password was changed; your other sessions were closed.';

  @override
  String get profileSignOut => 'Sign out';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionAppearance => 'Appearance';

  @override
  String get settingsSectionLanguage => 'Language';

  @override
  String get settingsSectionAccessibility => 'Accessibility';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsHighContrast => 'High contrast';

  @override
  String get settingsHighContrastHelp =>
      'At least 7:1 contrast for text and lines.';

  @override
  String get settingsLanguageSystem => 'Device language';

  @override
  String get settingsTextScale => 'Text size';

  @override
  String settingsTextScaleValue(int percent) {
    return '$percent%';
  }

  @override
  String get settingsReduceMotion => 'Reduce motion';

  @override
  String get settingsReduceMotionHelp =>
      'Turns off transition and slide animations.';

  @override
  String get settingsShortcuts => 'Keyboard shortcuts';

  @override
  String get settingsShortcutSearch => 'Go to search';

  @override
  String get settingsShortcutNew => 'New record';

  @override
  String get settingsShortcutSave => 'Save';

  @override
  String get settingsShortcutRefresh => 'Refresh';

  @override
  String get settingsShortcutClose => 'Close details';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get settingsAboutBody =>
      'The Vakıf Atlas management client for staff of the General Directorate of Foundations. Developed by Root42.';

  @override
  String get catalogTitle => 'Catalog';

  @override
  String get catalogSubtitle =>
      'VGM-approved foundation monuments. Changes appear immediately in the citizen app and on the map.';

  @override
  String get catalogSearch => 'Search name, city, founder or ID';

  @override
  String get catalogNew => 'New monument';

  @override
  String get catalogFilterCategory => 'Type';

  @override
  String get catalogFilterPeriod => 'Period';

  @override
  String get catalogFilterPublication => 'Publication';

  @override
  String get catalogSortName => 'By name';

  @override
  String get catalogSortUpdated => 'Recently updated';

  @override
  String get publicationPublished => 'Published';

  @override
  String get publicationArchived => 'Unpublished';

  @override
  String get categoryMosque => 'Mosque';

  @override
  String get categoryComplex => 'Complex';

  @override
  String get categoryMadrasa => 'Madrasa';

  @override
  String get categoryInn => 'Inn';

  @override
  String get categoryCaravanserai => 'Caravanserai';

  @override
  String get categoryBath => 'Bath';

  @override
  String get categoryFountain => 'Fountain';

  @override
  String get categoryTomb => 'Tomb';

  @override
  String get categoryHospital => 'Hospital';

  @override
  String get categoryImaret => 'Imaret';

  @override
  String get categoryMonumentOther => 'Other';

  @override
  String get periodSeljuk => 'Seljuk';

  @override
  String get periodBeylik => 'Beylik';

  @override
  String get periodOttoman => 'Ottoman';

  @override
  String get periodOther => 'Other';

  @override
  String catalogImageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count images',
      one: '1 image',
      zero: 'No images',
    );
    return '$_temp0';
  }

  @override
  String catalogMemberCount(int count) {
    return '$count buildings';
  }

  @override
  String catalogPartOf(String name) {
    return 'Part of $name';
  }

  @override
  String catalogRowSemantics(
    String name,
    String category,
    String city,
    String publication,
  ) {
    return '$name, $category, $city, $publication';
  }

  @override
  String get editorNewTitle => 'New monument';

  @override
  String get editorBack => 'Back to catalog';

  @override
  String get editorTabGeneral => 'General';

  @override
  String get editorTabTurkish => 'Turkish';

  @override
  String get editorTabEnglish => 'English';

  @override
  String get editorTabImages => 'Images';

  @override
  String get editorTabMembers => 'Complex buildings';

  @override
  String editorTabHasErrors(String tab) {
    return '$tab, has fields to fix';
  }

  @override
  String get editorSave => 'Save';

  @override
  String get editorSaved => 'Monument saved';

  @override
  String get editorDiscard => 'Revert changes';

  @override
  String get editorUnsaved => 'Unsaved changes';

  @override
  String get editorErrorsSummary => 'Fix the highlighted fields before saving.';

  @override
  String get editorArchive => 'Unpublish';

  @override
  String get editorRestore => 'Republish';

  @override
  String get editorArchiveConfirmTitle => 'Unpublish this monument?';

  @override
  String get editorArchiveConfirmBody =>
      'The monument disappears from the citizen app and the map; routes, saved items and memories show it as removed from the catalog. It can be republished later.';

  @override
  String editorArchivedNotice(String date) {
    return 'This monument is not published ($date).';
  }

  @override
  String get editorPublicationChanged => 'Publication status updated';

  @override
  String get editorFieldId => 'ID (URL)';

  @override
  String get editorFieldIdHelp =>
      'Lowercase letters, digits and hyphens; cannot change after saving. E.g. selimiye-camii';

  @override
  String get editorFieldIdError =>
      '3–120 characters; only lowercase letters, digits and single hyphens.';

  @override
  String get editorSuggestId => 'Suggest from name';

  @override
  String get editorFieldCategory => 'Type';

  @override
  String get editorFieldPeriod => 'Period';

  @override
  String get editorFieldCity => 'City';

  @override
  String get editorFieldDistrict => 'District';

  @override
  String get editorFieldAddress => 'Address';

  @override
  String get editorFieldLatitude => 'Latitude';

  @override
  String get editorFieldLongitude => 'Longitude';

  @override
  String get editorFieldLocationError =>
      'Enter a valid coordinate within Türkiye (decimal degrees).';

  @override
  String get editorFieldLocationHelp =>
      'Decimal degrees (WGS 84), e.g. 41.6781 / 26.5594.';

  @override
  String get editorFieldUnesco => 'UNESCO World Heritage';

  @override
  String get editorFieldComplex => 'Parent complex';

  @override
  String get editorFieldComplexHelp =>
      'If the monument is a structure of a complex, pick it from the list; otherwise leave it independent. A complex cannot belong to another complex.';

  @override
  String get editorFieldComplexError =>
      'The selected complex is invalid. Pick it again from the list.';

  @override
  String get editorFieldComplexOrder => 'Order in the complex';

  @override
  String get editorFieldRequired => 'This field is required.';

  @override
  String get editorFieldName => 'Name';

  @override
  String get editorFieldShortDescription => 'Short description';

  @override
  String get editorFieldShortDescriptionHelp =>
      'Shown in lists and cards (up to 1000 characters).';

  @override
  String get editorFieldDescription => 'Description';

  @override
  String get editorFieldDescriptionHelp =>
      'Separate paragraphs with a blank line.';

  @override
  String get editorFieldHistory => 'History';

  @override
  String get editorFieldConstructionDate => 'Construction date';

  @override
  String get editorFieldFounder => 'Founder';

  @override
  String get editorFieldArchitect => 'Architect';

  @override
  String get editorImagesHelp =>
      'The first image is the cover. Each image needs alternative text in both languages, an author and a licence (attribution). Up to 10 images.';

  @override
  String get editorImagesAdd => 'Add images';

  @override
  String editorImagesUploading(int count) {
    return 'Preparing and uploading $count images…';
  }

  @override
  String editorImagesUploadError(String reason) {
    return 'The image could not be uploaded: $reason';
  }

  @override
  String get editorImagesInvalid =>
      'The file could not be read or is in an unsupported format.';

  @override
  String get editorImagesError =>
      'Enter alternative text (TR/EN), author and licence for every image.';

  @override
  String get editorImagesEmpty => 'No images yet.';

  @override
  String get editorImageCover => 'Cover';

  @override
  String get editorImageNew => 'New';

  @override
  String get editorImageMirrored => 'In VGM storage';

  @override
  String get editorImageAltTr => 'Alternative text (TR)';

  @override
  String get editorImageAltEn => 'Alternative text (EN)';

  @override
  String get editorImageAuthor => 'Author';

  @override
  String get editorImageLicense => 'Licence';

  @override
  String get editorImageSourceName => 'Source';

  @override
  String get editorImageSourceUrl => 'Source URL';

  @override
  String get editorImageMoveUp => 'Move up';

  @override
  String get editorImageMoveDown => 'Move down';

  @override
  String get editorImageRemove => 'Remove image';

  @override
  String editorImageSemantics(int index, int count) {
    return 'Image $index of $count';
  }

  @override
  String get editorImagesFileType => 'Images';

  @override
  String get editorMembersHelp =>
      'Curated order of the structures (usually the mosque first). Pick structures from the list to add them; the complex footprint is recalculated when membership and order are saved.';

  @override
  String get editorMembersSaveFirst =>
      'Buildings can be edited after the complex is saved.';

  @override
  String get editorMembersAdd => 'Add building';

  @override
  String get editorMembersSave => 'Save buildings';

  @override
  String get editorMembersSaved => 'Complex buildings saved';

  @override
  String get editorMembersEmpty => 'No buildings belong to this complex.';

  @override
  String get editorMemberRemove => 'Remove from complex';

  @override
  String get editorMemberArchived => 'not published';

  @override
  String editorMemberOrder(int index, String name) {
    return '$index. $name';
  }

  @override
  String get appBrandName => 'Vakıf Atlas';

  @override
  String filterSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get filterClearSelection => 'Clear selection';

  @override
  String get catalogColumnName => 'Monument';

  @override
  String get catalogColumnCategory => 'Type';

  @override
  String get catalogColumnPeriod => 'Period';

  @override
  String get catalogColumnLocation => 'Location';

  @override
  String get catalogColumnImages => 'Images';

  @override
  String get catalogColumnStatus => 'Status';

  @override
  String get catalogColumnUpdated => 'Updated';

  @override
  String get dashboardMetricOpenReports => 'Open damage reports';

  @override
  String get dashboardMetricModeration => 'Memories awaiting action';

  @override
  String get dashboardMetricFeedback => 'New feedback';

  @override
  String get dashboardMetricCatalog => 'Published monuments';

  @override
  String get dashboardReportsNoCritical => 'No critical reports';

  @override
  String get dashboardOpenQueue => 'Open queue';

  @override
  String get dashboardOpenCatalog => 'Open catalog';

  @override
  String get dashboardByStatus => 'By status';

  @override
  String get dashboardOpenByUrgency => 'Open reports by urgency';

  @override
  String get dashboardByTopic => 'By topic';

  @override
  String get dashboardByCategory => 'By type';

  @override
  String get dashboardModerationReportedLabel => 'Reported';

  @override
  String get dashboardCatalogState => 'Publication';

  @override
  String get dashboardCatalogNoImages => 'Without images';

  @override
  String get dashboardCatalogVersionLabel => 'Catalog version';

  @override
  String get auditFilterDate => 'Date';

  @override
  String get editorFieldComplexOrderHelp =>
      'Position in the complex\'s structure list.';

  @override
  String get editorComplexNone =>
      'Independent monument (not part of a complex)';

  @override
  String get editorComplexChoose => 'Choose complex';

  @override
  String get editorComplexChange => 'Change';

  @override
  String get editorComplexClear => 'Remove link';

  @override
  String get editorFieldShortDescriptionTitle => 'Short description heading';

  @override
  String get editorFieldKind => 'Record type';

  @override
  String get editorKindWork => 'Work';

  @override
  String get editorKindComplex => 'Complex';

  @override
  String get editorCategoryAuto => 'Derive type from the name';

  @override
  String get editorCategoryAutoHelp =>
      'The type is derived from the last building word of the Turkish name (e.g. “… Camii Şadırvanı” → fountain). Turn off to choose it yourself.';

  @override
  String get editorFieldActive => 'Active';

  @override
  String get editorFieldActiveHelp =>
      'When off, the record is hidden in the citizen app.';

  @override
  String get editorComplexOpen => 'Open complex';

  @override
  String get editorComplexMembershipHelp =>
      'Complex membership and order are edited on the complex’s “Complex buildings” tab.';

  @override
  String editorComplexPosition(int position) {
    return 'Position in complex: $position';
  }

  @override
  String get pickerComplexTitle => 'Choose complex';

  @override
  String get pickerComplexSearch => 'Search by complex name, province or ID';

  @override
  String get pickerMembersTitle => 'Add structures to the complex';

  @override
  String get pickerMembersSearch => 'Search by monument name, province or ID';

  @override
  String get pickerMembersHelp =>
      'You can select several structures. A structure from another complex moves to this one when the structures are saved.';

  @override
  String pickerResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count records',
      one: '1 record',
      zero: 'No records',
    );
    return '$_temp0';
  }

  @override
  String pickerSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count structures selected',
      one: '1 structure selected',
      zero: 'Nothing selected',
    );
    return '$_temp0';
  }

  @override
  String pickerAdd(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Add $count structures',
      one: 'Add 1 structure',
      zero: 'Add',
    );
    return '$_temp0';
  }

  @override
  String get pickerAlreadyMember => 'Already in this complex';

  @override
  String get pickerCurrent => 'Current selection';

  @override
  String pickerInOtherComplex(String name) {
    return 'Currently in $name; adding moves it here';
  }

  @override
  String get roleEditor => 'Editor';

  @override
  String get roleModerator => 'Moderator';

  @override
  String get roleAdminDescription =>
      'All sections, staff management and the audit log';

  @override
  String get roleEditorDescription =>
      'Catalog only: add, edit and unpublish monuments, manage complex relations';

  @override
  String get roleModeratorDescription =>
      'User content only: Memory Corner, Civil Protection reports and feedback';

  @override
  String get settingsReduceMotionLocked =>
      'Reduce motion is on in your device settings and the app always follows it. Turn it off in system settings.';

  @override
  String get moderationQueueAutoRejected => 'Removed by AI';

  @override
  String get moderationEmptyAutoRejected => 'No memories were removed by AI.';

  @override
  String get moderationSortLabel => 'Order';

  @override
  String get moderationSortOldest => 'Oldest first';

  @override
  String get moderationSortAiScore => 'Highest AI score first';

  @override
  String get moderationMetricsAction => 'AI metrics';

  @override
  String get aiVerdictApprove => 'AI: acceptable';

  @override
  String get aiVerdictReview => 'AI: needs review';

  @override
  String get aiVerdictReject => 'AI: removed';

  @override
  String get aiVerdictUnscored => 'AI: not scored';

  @override
  String aiChip(String verdict, String score) {
    return '$verdict · $score';
  }

  @override
  String aiChipWithCategory(String verdict, String score, String category) {
    return '$verdict · $score · $category';
  }

  @override
  String get aiCategoryToxicity => 'General toxicity';

  @override
  String get aiCategorySevereToxicity => 'Severe toxicity';

  @override
  String get aiCategoryObscene => 'Obscene language';

  @override
  String get aiCategoryIdentityAttack => 'Identity attack';

  @override
  String get aiCategoryInsult => 'Insult';

  @override
  String get aiCategoryThreat => 'Threat';

  @override
  String get aiCategorySexualExplicit => 'Sexually explicit';

  @override
  String get aiReviewCauseScore => 'Score in the review band';

  @override
  String get aiReviewCauseLanguage => 'Language not supported by the model';

  @override
  String get aiReviewCausePhotos => 'Memories with photos are reviewed';

  @override
  String get aiReviewCauseUnscored => 'Moderation service was unavailable';

  @override
  String get memorySectionAi => 'AI assessment';

  @override
  String get aiVerdictLabel => 'Suggestion';

  @override
  String get aiScoreLabel => 'Overall score (0–1)';

  @override
  String get aiTopCategoryLabel => 'Main category';

  @override
  String get aiReviewCauseLabel => 'Review reason';

  @override
  String get aiLexiconLabel => 'Turkish lexicon match';

  @override
  String get aiLexiconYes => 'Yes — score raised by the lexicon';

  @override
  String get aiLexiconNo => 'No';

  @override
  String get aiModelLabel => 'Model';

  @override
  String get aiScoredAtLabel => 'Assessed at';

  @override
  String get aiCategoryScores => 'Category scores';

  @override
  String get aiNotAssessed =>
      'This memory was shared before AI moderation was enabled.';

  @override
  String get aiActorName => 'AI moderation';

  @override
  String get decisionRestoreAi => 'Restore (override AI)';

  @override
  String get dashboardModerationAutoRejected => 'Removed by AI (24 h)';

  @override
  String get dashboardModerationUnscored => 'Not scored';

  @override
  String get moderationMetricsTitle => 'AI moderation metrics';

  @override
  String moderationMetricsSubtitle(
    String model,
    String approve,
    String reject,
  ) {
    return 'Model $model · auto-publish < $approve · review $approve–$reject · auto-remove ≥ $reject';
  }

  @override
  String get moderationMetricsPeriod => 'Period';

  @override
  String moderationMetricsDays(int count) {
    return 'Last $count days';
  }

  @override
  String get moderationMetricsBack => 'Back to queue';

  @override
  String moderationMetricsModeOff(String mode) {
    return 'AI moderation is off (mode: $mode). Metrics are only collected in AI mode.';
  }

  @override
  String get metricsShared => 'Memories shared';

  @override
  String get metricsAutoApproved => 'Auto-published';

  @override
  String get metricsReview => 'Sent to review';

  @override
  String get metricsAutoRejected => 'Auto-removed';

  @override
  String get metricsUnscored => 'Not scored';

  @override
  String metricsShareOfTotal(String percent) {
    return '$percent% of total';
  }

  @override
  String get metricsHumanReviewTitle => 'Human review';

  @override
  String get metricsWaiting => 'Waiting in queue';

  @override
  String get metricsOldestWaiting => 'Oldest waiting';

  @override
  String get metricsDecided => 'Decided (review band)';

  @override
  String get metricsReviewApproved => 'Published';

  @override
  String get metricsReviewRejected => 'Removed';

  @override
  String get metricsMedianDecision => 'Median decision time';

  @override
  String metricsMinutes(int count) {
    return '$count min';
  }

  @override
  String metricsHours(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String metricsDaysDuration(int count) {
    return '$count days';
  }

  @override
  String get metricsAccuracyTitle => 'Accuracy (staff corrections)';

  @override
  String get metricsAutoRejectRestored => 'Auto-removals restored';

  @override
  String get metricsAutoApproveRemoved => 'Auto-publications removed later';

  @override
  String get metricsOverrideRate => 'Override rate of AI removals';

  @override
  String get metricsReviewApprovalRate => 'Publication rate in review';

  @override
  String metricsPercent(String percent) {
    return '$percent%';
  }

  @override
  String get metricsHistogramTitle => 'Score distribution and current status';

  @override
  String metricsBinLabel(
    String from,
    String to,
    int approved,
    int pending,
    int rejected,
  ) {
    return '$from–$to · $approved published · $pending waiting · $rejected removed';
  }

  @override
  String get metricsCategoriesTitle => 'Categories in reviewed and removed';

  @override
  String get metricsModelTitle => 'Model and thresholds';

  @override
  String get metricsModelVersion => 'Model version';

  @override
  String get metricsApproveThreshold => 'Auto-publish';

  @override
  String get metricsRejectThreshold => 'Auto-remove';

  @override
  String get metricsPhotoRule => 'Memories with photos';

  @override
  String get metricsPhotoRuleReview => 'Sent to review';

  @override
  String get metricsPhotoRuleText => 'Decided by text';

  @override
  String get metricsLatencyP50 => 'Scoring time (median)';

  @override
  String get metricsLatencyP95 => 'Scoring time (p95)';

  @override
  String metricsMs(int count) {
    return '$count ms';
  }

  @override
  String get metricsDailyTitle => 'Daily decisions';

  @override
  String metricsDayLine(int approved, int review, int rejected) {
    return '$approved published · $review review · $rejected removed';
  }

  @override
  String get metricsNoData => 'No memories were assessed by AI in this period.';

  @override
  String get editorTabParts => 'Sections';

  @override
  String get editorPartsHelp =>
      'Sections from the VGM data (e.g. the mosque and madrasa parts). Shown under separate headings on the monument page; Turkish text is required, and empty English falls back to Turkish.';

  @override
  String get editorPartsEmpty => 'No sections.';

  @override
  String get editorPartsError => 'Every section needs Turkish text.';

  @override
  String editorPartTitle(int index) {
    return 'Section $index';
  }

  @override
  String get editorPartRemove => 'Remove section';

  @override
  String get editorPartAdd => 'Add section';

  @override
  String get editorPartFieldTitleTr => 'Title (Turkish)';

  @override
  String get editorPartFieldTitleEn => 'Title (English)';

  @override
  String get editorPartFieldDescriptionTr => 'Text (Turkish)';

  @override
  String get editorPartFieldDescriptionEn => 'Text (English)';

  @override
  String get editorFieldNickname => 'Popular name';

  @override
  String editorImagePart(int index) {
    return 'Section $index';
  }

  @override
  String get catalogFilterLocation => 'Location';

  @override
  String get catalogLocationPresent => 'Location provided';

  @override
  String get catalogLocationMissing => 'Location missing';

  @override
  String get catalogNoLocation => 'No location';

  @override
  String get catalogImport => 'Import';

  @override
  String get errorConflictImportImages =>
      'Some images have not yet been uploaded. Restart the import to send only the missing images.';

  @override
  String get importTitle => 'Import VGM data';

  @override
  String get importSubtitle =>
      'Imports monument and complex data (JSON) with its images into the catalog';

  @override
  String get importSourceTitle => 'Source folder';

  @override
  String get importSourceHelp =>
      'Select the folder containing the data file (root42-veri.json) and images folder. Image paths are relative to the data file.';

  @override
  String get importNoFolder => 'No folder selected';

  @override
  String get importPickFolder => 'Select folder';

  @override
  String get importChangeFolder => 'Change folder';

  @override
  String get importNoJson => 'No JSON file found in the folder.';

  @override
  String get importJsonFile => 'Data file';

  @override
  String importLocalSummary(int count, String megabytes) {
    return '$count image files read ($megabytes MB).';
  }

  @override
  String get importReading => 'Reading files and computing image checksums…';

  @override
  String get importPlanning => 'The server is checking the file…';

  @override
  String get importPlanTitle => 'Import plan';

  @override
  String get importStatusValid => 'Valid';

  @override
  String get importStatusInvalid => 'Invalid';

  @override
  String get importStatusCommitted => 'Completed';

  @override
  String get importCountComplexes => 'Complexes';

  @override
  String get importCountWorks => 'Monuments';

  @override
  String get importCountParts => 'Sections';

  @override
  String get importCountImages => 'Images';

  @override
  String importCountImagesValue(int total, int unique) {
    return '$total ($unique distinct files)';
  }

  @override
  String get importCountNew => 'Records to be added';

  @override
  String get importCountExisting => 'Records to be updated';

  @override
  String get importCountMissingImages => 'Images to be uploaded';

  @override
  String get importMergeNotice =>
      'For existing records, the location, history, founder, architect and corrected type/period entered in the panel are kept. The data file has no coordinates, so new monuments stay off the map until a location is entered.';

  @override
  String get importStart => 'Import';

  @override
  String importStartWithImages(int count) {
    return 'Upload $count images and import';
  }

  @override
  String get importCancel => 'Stop';

  @override
  String get importCancelling =>
      'Stopping once the uploads in progress finish…';

  @override
  String get importProgressTitle => 'Progress';

  @override
  String importUploadProgress(int done, int total) {
    return '$done / $total images uploaded';
  }

  @override
  String importUploadFailed(int count) {
    return '$count images could not be uploaded. Restarting sends only the missing ones.';
  }

  @override
  String get importCommitting => 'Records are being written to the catalog…';

  @override
  String get importResultTitle => 'Result';

  @override
  String get importResultCreated => 'Works added';

  @override
  String get importResultUpdated => 'Works updated';

  @override
  String get importResultComplexesCreated => 'Complexes added';

  @override
  String get importResultComplexesUpdated => 'Complexes updated';

  @override
  String get importResultVersion => 'Catalog version';

  @override
  String get importOpenMissingLocation => 'Open monuments without a location';

  @override
  String importErrorsTitle(int count) {
    return 'Errors ($count)';
  }

  @override
  String importWarningsTitle(int count) {
    return 'Warnings ($count)';
  }

  @override
  String importMoreIssues(int count) {
    return '… and $count more issues';
  }

  @override
  String get importPlanReady => 'File is valid; import plan is ready.';

  @override
  String get importPlanInvalid => 'The file has errors and cannot be imported.';

  @override
  String get importDone => 'Import completed.';

  @override
  String get importLeaveTitle => 'Import in progress';

  @override
  String get importLeaveMessage =>
      'Leaving this page stops the upload. Uploaded images are kept; restarting sends only the rest.';

  @override
  String get importIssueInvalidJson =>
      'File is not valid JSON or does not match the schema';

  @override
  String get importIssueMissingFile => 'Image file not found';

  @override
  String get importIssueFileTooLarge => 'Image is too large (5 MB max)';

  @override
  String get importIssueFormatVersion => 'Unsupported format version';

  @override
  String get importIssueRequired => 'Required field is empty';

  @override
  String get importIssueTooLong => 'Field is too long';

  @override
  String get importIssueInvalidKey =>
      'Invalid key (lowercase letters, digits and hyphens; at most 111 characters)';

  @override
  String get importIssueDuplicateKey => 'Key used multiple times';

  @override
  String get importIssueSlug => 'Invalid or duplicate slug';

  @override
  String get importIssueUnknownCity => 'Unknown province code';

  @override
  String get importIssueInvalidSrc => 'Invalid image path';

  @override
  String get importIssueTooManyImages => 'Too many images';

  @override
  String get importIssueUnknownMember =>
      'Complex lists a monument that is not in the file';

  @override
  String get importIssueMemberTwice => 'Monument belongs to two complexes';

  @override
  String get importIssueMemberCity =>
      'Monument\'s province differs from the complex\'s';

  @override
  String get importIssueDuplicateMember =>
      'Same monument listed twice in the complex';

  @override
  String get importWarningRenamed =>
      'Complex key matches a monument; the complex ID was changed';

  @override
  String get importWarningCategory =>
      'Type could not be derived from the name (Other)';

  @override
  String get importWarningDuplicateTitle =>
      'Another monument has the same name';

  @override
  String get importWarningNoDistrict =>
      'District could not be derived from address';

  @override
  String get importWarningNoImages => 'No image';

  @override
  String get reportsFilterEvidence => 'AI evidence';

  @override
  String get reportsSortEvidence => 'Urgency, then AI evidence';

  @override
  String get reportSectionEvidence => 'AI evidence assessment';

  @override
  String get evidenceLevelStrong => 'Strong evidence';

  @override
  String get evidenceLevelUnverified => 'Unverified';

  @override
  String get evidenceLevelSuspicious => 'Suspicious';

  @override
  String get evidenceLevelPending => 'Not assessed';

  @override
  String evidenceChip(String level) {
    return 'AI: $level';
  }

  @override
  String evidenceChipSemantics(String level) {
    return 'AI evidence label: $level';
  }

  @override
  String get evidenceLevelLabel => 'Label';

  @override
  String get evidenceHelpStrong =>
      'No negative signs; at least two independent pieces of evidence, or one plus a description of damage. Can be looked at first.';

  @override
  String get evidenceHelpUnverified =>
      'No negative signs, but the evidence is weak. Normal review.';

  @override
  String get evidenceHelpSuspicious =>
      'A concrete negative sign, or the description does not describe damage and nothing supports it. Review carefully; urgency order is unchanged.';

  @override
  String get evidenceHelpPending =>
      'Not scored yet; assessed in the background (retried for 24 hours if the moderation service is down).';

  @override
  String get evidenceDisclaimer =>
      'The label is only an aid: it never changes the status and is not shown to the citizen. AI cannot tell whether a report is true; it only measures how strong the evidence is.';

  @override
  String get evidenceSupports => 'Supporting';

  @override
  String get evidenceUndermines => 'Undermining';

  @override
  String get evidenceNeutral => 'Information';

  @override
  String evidenceReasonSemantics(String effect, String reason) {
    return '$effect: $reason';
  }

  @override
  String evidenceLocationOnSite(int distance) {
    return 'Location on site: $distance m from the monument';
  }

  @override
  String evidenceLocationDistant(int distance) {
    return 'Location far from the monument: $distance m';
  }

  @override
  String get evidenceLocationNotProvided => 'No location attached';

  @override
  String evidenceCorroborated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count other accounts reported this monument in the last 14 days',
      one: '1 other account reported this monument in the last 14 days',
    );
    return '$_temp0';
  }

  @override
  String evidencePhotoMatches(String score) {
    return 'Photo resembles the monument\'s catalogue images (similarity $score)';
  }

  @override
  String evidencePhotoLowSimilarity(String score) {
    return 'Photo does not resemble the catalogue images (similarity $score); may be a close-up of damage, not counted against';
  }

  @override
  String get evidencePhotoNone => 'No photo attached';

  @override
  String evidencePhotoUnreadable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos could not be read',
      one: '1 photo could not be read',
    );
    return '$_temp0';
  }

  @override
  String evidencePhotoCatalogCopy(String score) {
    return 'Photo may be a copy of a catalogue image (similarity $score)';
  }

  @override
  String evidencePhotoNsfw(String score) {
    return 'Explicit photo (probability $score)';
  }

  @override
  String evidenceTextDescribesDamage(String score) {
    return 'Description describes damage (score $score)';
  }

  @override
  String evidenceTextWeakDamage(String score) {
    return 'Description of damage is vague (score $score)';
  }

  @override
  String evidenceTextNotDamage(String score) {
    return 'Description does not describe damage (score $score)';
  }

  @override
  String evidenceTextAbusive(String score) {
    return 'Abusive / toxic language in description (score $score)';
  }

  @override
  String evidenceTextSpam(String signals) {
    return 'Description matches spam rules: $signals';
  }

  @override
  String evidenceTextContact(String signals) {
    return 'Description contains contact details ($signals); may be personal data';
  }

  @override
  String evidenceCategorySuggested(String category) {
    return 'Description is closer to another type: $category (suggestion only)';
  }

  @override
  String evidenceUrgencyUnsupported(String urgency) {
    return 'Urgency \"$urgency\" without independent evidence (order unchanged)';
  }

  @override
  String evidenceUnknown(String code) {
    return 'Other signal: $code';
  }

  @override
  String get dashboardOpenByEvidence => 'Open reports by AI evidence';

  @override
  String get aiSpamSignalContact => 'contact details';

  @override
  String get aiSpamSignalPromotion => 'commercial offer';

  @override
  String get aiSpamSignalScam => 'scam pattern';

  @override
  String get aiCategoryNsfw => 'Explicit photo';

  @override
  String get aiCategoryUnrelated => 'Unrelated to monument';

  @override
  String get aiCategorySpam => 'Spam / advertising';

  @override
  String get aiReviewCauseNsfw => 'Photo may be explicit';

  @override
  String get aiReviewCauseSpam => 'Contains contact details (possible spam)';

  @override
  String get aiReviewCauseUnrelated => 'Photo does not resemble the monument';

  @override
  String get aiReviewCauseContext => 'Text is weakly related to the monument';

  @override
  String get aiSpamLabel => 'Spam score';

  @override
  String get aiSpamSignalsLabel => 'Matched spam rules';

  @override
  String get aiRelevanceLabel => 'Text relevance to monument';

  @override
  String get aiNsfwLabel => 'Explicitness (highest photo)';

  @override
  String get aiSimilarityLabel => 'Monument similarity (lowest photo)';

  @override
  String get aiVisionModelLabel => 'Vision model';

  @override
  String get aiContextModelLabel => 'Context index';

  @override
  String get aiPhotoScores => 'Photo scores';

  @override
  String aiPhotoLabel(int index) {
    return 'Photo $index';
  }

  @override
  String aiPhotoScoresValue(String nsfw, String similarity) {
    return 'explicitness $nsfw · monument similarity $similarity';
  }

  @override
  String get aiPhotoNoReference => 'no reference images';

  @override
  String get aiPhotoUnreadable => 'unreadable';
}
