Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F28738AF7
	for <lists+linux-bcache@lfdr.de>; Wed, 21 Jun 2023 18:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbjFUQYC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 21 Jun 2023 12:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232575AbjFUQXj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Jun 2023 12:23:39 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79044199D;
        Wed, 21 Jun 2023 09:23:35 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2AEA91FF26;
        Wed, 21 Jun 2023 16:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1687364614; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=dFMthcxHoQIQg1Ebyle1kYkNFdaMWRonSov7ryWuJPM=;
        b=ZUsbPcgEM4aL/iyH0mvq2MyLMu1Dkm02Uc5K+vVfwLLHsL7SwcWkzTANA3bmSJ7QTTUjwO
        M9oEu0OjCn+VBob+TYM6YCRy8DYLjM3bHp44kSm36YY2AWMxAavtCEivd7KdV4Igs5KNto
        J/UzEKzgp5nQDbH/BaR06W2AcLJq1eA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1687364614;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=dFMthcxHoQIQg1Ebyle1kYkNFdaMWRonSov7ryWuJPM=;
        b=Y997rZ26bo/QHtQ8dUf6FnJ97lEamtZAnOIrOqB+Bg97ujW4PRex2uFZt/9tyarRdRjYWX
        xOTdSbdBGwwX7AAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1229C133E6;
        Wed, 21 Jun 2023 16:23:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ZjlmBAYkk2TDPQAAMHmgww
        (envelope-from <jack@suse.cz>); Wed, 21 Jun 2023 16:23:34 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 85986A075D; Wed, 21 Jun 2023 18:23:33 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        <linux-block@vger.kernel.org>, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] bcache: Fix block device claiming
Date:   Wed, 21 Jun 2023 18:23:25 +0200
Message-Id: <20230621162024.29310-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=254; i=jack@suse.cz; h=from:subject:message-id; bh=wqnu4wImZoVGaVmdUAOZ4QnZN4UycfxJYY0gKyVa/KM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBkkyPy9WSe+ZodxfVzN6i4pTWgf6wYhYyRYtdnBr1z 6gZtQVKJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZJMj8gAKCRCcnaoHP2RA2ex0CA DXJgWadfvIEEdoZ1g1nibLz9Ejm/iMA19C2q+8RxmS3QHTIobafTvBBxXFU5qmmXBlSYfxuJSRT7uJ Cvy4zDpXHvl53Qm5qx3718CbaNkH4tSuELd6iCdL6VvO60WiqNRQzi4UT81T4M2Wz7Z1ngQqqYJbTw SNiBuFVSVYz25yd2GS7QichO8h/ciYuKa4tnrY+KRv6BjakrLxEcygf2ovgv5ryGTp9E4Dy55uJaP4 mlDsi/ZalawUg0y2FVSu/yMrFiYwT4e5OxIg3F0IpJd7pErYoJfY+9EH4sLAaKQ2CEa3MkVub2m1ES Plre+pMbrWUptM/xVvciX9op2IUFNl
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello,

these two patches fix block device claiming for bcache broken by recent
Christoph's changes to blkdev_get_*() functions and also cleans up the layering
violation inside bcache which was the underlying cause of the breakage.

								Honza
