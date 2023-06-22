Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E96173A665
	for <lists+linux-bcache@lfdr.de>; Thu, 22 Jun 2023 18:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbjFVQrE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 22 Jun 2023 12:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbjFVQrC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 22 Jun 2023 12:47:02 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93088E48;
        Thu, 22 Jun 2023 09:47:00 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A76D521BB7;
        Thu, 22 Jun 2023 16:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1687452418; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=9XhVVq4Az2Jd7jLAWVpuEhRk7Nf3E7yVh0p+6lmDRuM=;
        b=yZyRGtAOcFmImIv32mh2dwuXUMZghr42WRjlQoeDJFklN4CcrnM7IBTjx3ceIw0DQlvpDq
        AbkWY/DXNx3j0Ijb6I9j8hQQlehSZsBzDv+Y/03K5wwN0EUWlTBvSqYtHvU+YEDlBpZtiG
        hNNXj+ReCEpl42KKO0LbXxL9pWGWkXE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1687452418;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=9XhVVq4Az2Jd7jLAWVpuEhRk7Nf3E7yVh0p+6lmDRuM=;
        b=ygXHhE54RZ/34JN07bStjqUxw88Tf5b3mc6+9qxDmXIF9BktAavCo6MLl4faqvo6kR+JGU
        Qyi3GKakXMOVYtAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9917513905;
        Thu, 22 Jun 2023 16:46:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id jiJYJQJ7lGSHSwAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 22 Jun 2023 16:46:58 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 23286A0754; Thu, 22 Jun 2023 18:46:58 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        <linux-block@vger.kernel.org>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH v2 0/2] bcache: Fix block device claiming
Date:   Thu, 22 Jun 2023 18:46:53 +0200
Message-Id: <20230622164149.17134-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=745; i=jack@suse.cz; h=from:subject:message-id; bh=6xMgV5oGlSE8j+rUmk3rzHGPthAU9hRmF2ycDtsiCbU=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBklHr4ZqazW8BcZ9f98zkJ01RquX5s/6FxEx+tWZbh T+N1fjSJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZJR6+AAKCRCcnaoHP2RA2UoBB/ 9J63l33SFpqI8/HVHZliR0lzE0Mjkf+NWX/8u244n8saJqz1c7kNOt4zjCLPAQNmGou4JPkSdtf/tV b03eFi6brFrCKFFabeYOqk3dFjHKCLubzit5nszv+h0V46EZr2NIeXCcw1gCHOx+Yo4QVwlrtuiQNj LspVYd3hri4nwgvv3hVeuZIFmdMYLdEX/SVg2c1i8MgE/hQws6lNtrn9njdt0cXphaNYAD1flYmL5f 8rnnpho8r2dnf8qy1OYeg96BLJTd2y5lSR/SQpmdnStWucIGbPndHK0eQL9PSO/bXbIhifNNjiRYan Tfh4b930Ce0E88N2XIhhCKzpbqG35j
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello,

these two patches fix block device claiming for bcache broken by recent
Christoph's changes to blkdev_get_*() functions and also cleans up the layering
violation inside bcache which was the underlying cause of the breakage.

This time I've actually tested various modified error handling paths (which was
good because one of them was indeed wrong!).

Jens, please consider merging these fixes before sending Linus a pull request
with blkdev changes.

Changes since v1:
* Fix compile breakage spotted by 0-day
* Fix error handling path when the second blkdev_get_by_dev() fails
* Fix commit message of patch 2/2

								Honza
Previous versions:
Link: http://lore.kernel.org/r/20230621162024.29310-1-jack@suse.cz # v1
