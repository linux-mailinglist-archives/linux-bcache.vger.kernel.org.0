Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B20A644729
	for <lists+linux-bcache@lfdr.de>; Tue,  6 Dec 2022 15:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235072AbiLFO6A (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 6 Dec 2022 09:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235204AbiLFO5U (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 6 Dec 2022 09:57:20 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655492FC3F;
        Tue,  6 Dec 2022 06:51:34 -0800 (PST)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9267F1FE36;
        Tue,  6 Dec 2022 14:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1670338293; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y1QA/VfgBDC1wZs2knAWjY99Zbr5hdIc3ImjrFUrhjk=;
        b=YGoqIO/FxZVZm7YPlo6VnN19GY1N+BTLUIRAH1kaAgoze+eqIboMAYoLATkdE8hqI9ZEpb
        YfZ+iVjBMS5M6SNmozP2rUNbmSj4V/jHzaV+5gaMYaYzQ9i9pYFHwv1HtvaZoFwhXriJFD
        Z0za+eD33v81Bt/jTZJVSr/d85ODO10=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1670338293;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y1QA/VfgBDC1wZs2knAWjY99Zbr5hdIc3ImjrFUrhjk=;
        b=mo1mdbErcw9tnjWYGCsPhZiWu6oQBpXvujnaeETWM6W81iLbJBMSCuF51SVENHEBEl+CvC
        avsi/ulsJpuisCDA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 6B12F132F3;
        Tue,  6 Dec 2022 14:51:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id 4f0yDfNWj2PiMQAAGKfGzw
        (envelope-from <colyli@suse.de>); Tue, 06 Dec 2022 14:51:31 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Subject: Re: [dm-devel] [PATCH] block: remove bio_set_op_attrs
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20221206144902.GA31845@lst.de>
Date:   Tue, 6 Dec 2022 22:51:17 +0800
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        snitzer@kernel.org, dm-devel@redhat.com,
        linux-raid <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>, linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <51D61E7A-055D-4F6F-AC4C-748D7E0C5E12@suse.de>
References: <20221206144057.720846-1-hch@lst.de>
 <434E4CE3-EA46-4CD9-9EAF-5C1B99B8A603@suse.de>
 <20221206144902.GA31845@lst.de>
To:     Christoph Hellwig <hch@lst.de>
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B412=E6=9C=886=E6=97=A5 22:49=EF=BC=8CChristoph Hellwig =
<hch@lst.de> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Tue, Dec 06, 2022 at 10:46:31PM +0800, Coly Li wrote:
>> BTW, may I ask why bio_set_op_attrs() is removed. Quite long time ago =
it was added to avoid open code, and now we remove it to use open coded =
assignments. What is the motivation for now?
>=20
> It was added when the flags encoding was a mess.  Now that the RQF_
> flags are split out things have become much simpler and we don't need
> to hide a simple assignment of a value to a field.

I see. Thanks for doing this.

Coly Li

