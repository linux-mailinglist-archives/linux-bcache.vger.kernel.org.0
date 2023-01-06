Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6074066027A
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Jan 2023 15:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjAFOtA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 6 Jan 2023 09:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234376AbjAFOs5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Jan 2023 09:48:57 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED6C80AF8
        for <linux-bcache@vger.kernel.org>; Fri,  6 Jan 2023 06:48:50 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B93FA24BE7
        for <linux-bcache@vger.kernel.org>; Fri,  6 Jan 2023 14:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673016528; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=3nwKpRFfYT2NVDiHDAvBpULAZTb5h/G6VPLA6BrACyU=;
        b=l2ChldOPsijT/ZJ+sQVqqePkb3aeEU44y3fHMF6x1fCRb/8OGckNjUuqli3e4E9x+MyJbG
        PrGgpRSglMT87+JfG6Gqv1wrTJyukdshhbmpytELYert7oAMRmBybX1zFDaAqZH74/sEqU
        BKUmAn2McA8BvONUXxveA9z6EC972bA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673016528;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=3nwKpRFfYT2NVDiHDAvBpULAZTb5h/G6VPLA6BrACyU=;
        b=PhQjRZbkK0epnZJE4KpYoiHq/EvvzdMR3muL4VrMs7clxBDsxKNmbEGxL3achTvs+pErCY
        iZnNGVCA3bQp4XDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 50E14139D5
        for <linux-bcache@vger.kernel.org>; Fri,  6 Jan 2023 14:48:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id B5B6BtA0uGMFBQAAMHmgww
        (envelope-from <colyli@suse.de>)
        for <linux-bcache@vger.kernel.org>; Fri, 06 Jan 2023 14:48:48 +0000
From:   Coly Li <colyli@suse.de>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: On vacation from Jan 9 to Jan 13
Message-Id: <E7732F91-5902-42E1-94A8-CBC6723BA70E@suse.de>
Date:   Fri, 6 Jan 2023 22:48:35 +0800
To:     linux-bcache@vger.kernel.org
X-Mailer: Apple Mail (2.3731.300.101.1.3)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi folks,

Now I just survived from the Omicron pandemic infection, and not totally =
recovered. Next week I will be on vacation, and it is predictable that =
all email, and bug report cannot be responded until I back to my laptop =
after Jan 14.

Just for your information, and hope all of you are safe and healthy.

Best regards,

Coly Li=
