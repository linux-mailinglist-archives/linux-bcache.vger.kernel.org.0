Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A8649FBD3
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Jan 2022 15:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349306AbiA1Oed (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 28 Jan 2022 09:34:33 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:50068 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245467AbiA1Oec (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Jan 2022 09:34:32 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 11E3E212B6;
        Fri, 28 Jan 2022 14:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1643380471; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d2GA+HB9wkXuvJ87Q5v9+tVwtDvLVyKwD4FaXVR7w/o=;
        b=DI6zpOJ0NGhzaEDdD7SETWObyvEMJuMN2HG4tDoaEoUuTrqR5bOU46Kx71fSwOhtkPXkbz
        xi+EaKrZ+nW2VDWN2zPSMGLHi7zRwimNnMTcAlXQ3aJ53dcSHe6HeivP62/E+HUnXmwz1/
        5dq9nykKOsKasURE16XF0XaU7SM224I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1643380471;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d2GA+HB9wkXuvJ87Q5v9+tVwtDvLVyKwD4FaXVR7w/o=;
        b=b0/Syh2DRN7jH5yGFNsRc6tAWcgNZbKrApZ3DL2gF3VFeWCbVJsiH1lgZsYc1OpoDbDe5u
        JDQ18XtSsKn++dAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 73EF913B02;
        Fri, 28 Jan 2022 14:34:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HXBbDvX+82G4KAAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 28 Jan 2022 14:34:29 +0000
Message-ID: <4c38baa1-9cb8-2ba5-36c0-251afc6e615b@suse.de>
Date:   Fri, 28 Jan 2022 22:34:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH] bcache: Fix a NULL or wild pointer dereference in
 btree_gc_rewrite_node()
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     kjlu@umn.edu, Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhou Qingyang <zhou1615@umn.edu>
References: <20220124164701.53525-1-zhou1615@umn.edu>
 <YfPC0B9mBE/hkKEO@kroah.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <YfPC0B9mBE/hkKEO@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/28/22 6:17 PM, Greg KH wrote:
> On Tue, Jan 25, 2022 at 12:47:01AM +0800, Zhou Qingyang wrote:
>> In btree_gc_rewrite_node(), btree_node_alloc_replacement() is assigned to
>> n and return error code or NULL on failure. n is passed to
>> bch_btree_node_write_sync() and there is a dereference of it in
>> bch_btree_node_write_sync() without checks, which may lead to wild
>> pointer dereference or NULL pointer dereference depending on n.
>>
>> Fix this bug by adding IS_ERR_OR_NULL check of n.
>>
>> This bug was found by a static analyzer.
>>
>> Builds with 'make allyesconfig' show no new warnings,
>> and our static analyzer no longer warns about this code.
>>
>> Fixes: ("bcache: Rework btree cache reserve handling")
>> Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
>> ---
>> The analysis employs differential checking to identify inconsistent
>> security operations (e.g., checks or kfrees) between two code paths
>> and confirms that the inconsistent operations are not recovered in the
>> current function or the callers, so they constitute bugs.
>>
>> Note that, as a bug found by static analysis, it can be a false
>> positive or hard to trigger. Multiple researchers have cross-reviewed
>> the bug.
>>
>>   drivers/md/bcache/btree.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
>> index 88c573eeb598..06d42292e86c 100644
>> --- a/drivers/md/bcache/btree.c
>> +++ b/drivers/md/bcache/btree.c
>> @@ -1504,6 +1504,8 @@ static int btree_gc_rewrite_node(struct btree *b, struct btree_op *op,
>>   		return 0;
>>   
>>   	n = btree_node_alloc_replacement(replace, NULL);
>> +	if (IS_ERR_OR_NULL(n))
>> +		return 0;
>>   
>>   	/* recheck reserve after allocating replacement node */
>>   	if (btree_check_reserve(b, NULL)) {
>> -- 
>> 2.25.1
>>
> As stated before, umn.edu is still not allowed to contribute to the
> Linux kernel.  Please work with your administration to resolve this
> issue.
>

Copied. Thanks for the reminding.

Coly Li
