Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2561A3AEC4B
	for <lists+linux-bcache@lfdr.de>; Mon, 21 Jun 2021 17:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhFUP15 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 21 Jun 2021 11:27:57 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33646 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbhFUP1y (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 21 Jun 2021 11:27:54 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id EB7A8219D2;
        Mon, 21 Jun 2021 15:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624289137; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bS/I+JK1XHQRs9zB6U84ELgbrTcyHlfEK12hqOtcO7o=;
        b=2LjGsPN6ufloBW9oIdTbj4sKsR5w/gc9/iDgQRr3fDnZALqEde1e6H9vCiOl0d4Xt6Nl8Y
        lYEz7xFJkVB888SCviavhrMji/di2OuPnjvD6STp9ZZdVbdHPhmn647W0LTBE+fFYb12ot
        psrTzyP6DgwdHdaSViYY2y3emzvufAA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624289137;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bS/I+JK1XHQRs9zB6U84ELgbrTcyHlfEK12hqOtcO7o=;
        b=yeU9q0TY0lBgw2PTpSA7wTpjwJmaWF5m8ONOTEWXI1pASCTv+SNTYf9tuf79PAiFcQ/QZN
        SFrELHMJiXmHclBA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 02B88118DD;
        Mon, 21 Jun 2021 15:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624289137; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bS/I+JK1XHQRs9zB6U84ELgbrTcyHlfEK12hqOtcO7o=;
        b=2LjGsPN6ufloBW9oIdTbj4sKsR5w/gc9/iDgQRr3fDnZALqEde1e6H9vCiOl0d4Xt6Nl8Y
        lYEz7xFJkVB888SCviavhrMji/di2OuPnjvD6STp9ZZdVbdHPhmn647W0LTBE+fFYb12ot
        psrTzyP6DgwdHdaSViYY2y3emzvufAA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624289137;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bS/I+JK1XHQRs9zB6U84ELgbrTcyHlfEK12hqOtcO7o=;
        b=yeU9q0TY0lBgw2PTpSA7wTpjwJmaWF5m8ONOTEWXI1pASCTv+SNTYf9tuf79PAiFcQ/QZN
        SFrELHMJiXmHclBA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id drbWLnCv0GD4DwAALh3uQQ
        (envelope-from <colyli@suse.de>); Mon, 21 Jun 2021 15:25:36 +0000
Subject: Re: [PATCH 00/14] bcache patches for Linux v5.14
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20210615054921.101421-1-colyli@suse.de>
 <cb427b5f-8e55-bed2-1e3d-7382a092d4a0@kernel.dk>
From:   Coly Li <colyli@suse.de>
Message-ID: <02e126b9-f4a8-8034-8c78-d06a3dc41acf@suse.de>
Date:   Mon, 21 Jun 2021 23:25:34 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cb427b5f-8e55-bed2-1e3d-7382a092d4a0@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/21/21 11:14 PM, Jens Axboe wrote:
> On 6/14/21 11:49 PM, Coly Li wrote:
>> Hi Jens,
>>
>> Here are the bcache patches for Linux v5.14.
>>
>> The patches from Chao Yu and Ding Senjie are useful code cleanup. The
>> rested patches for the NVDIMM support to bcache journaling.
>>
>> For the series to support NVDIMM to bache journaling, all reported
>> issue since last merge window are all fixed. And no more issue detected
>> during our testing or by the kernel test robot. If there is any issue
>> reported during they stay in linux-next, I, Jianpang and Qiaowei will
>> response and fix immediately.
>>
>> Please take them for Linux v5.14.
> I'd really like the user api bits to have some wider review. Maybe
> I'm missing something, but there's a lot of weird stuff in the uapi
> header that includes things like pointers etc.
>

Hi Jens,

As I explained 2 merge windows before, we use nvdimm as non-volatiled
memory, that is, the
memory objects are stored on nvdimm as memory object which are
non-volatiled. This is why
you see the pointers in the data structure, e.g. the list is stored on
NVDIMM area, and the code
goes through the list directly on the NVDIMM, we don't load them into
memory.

This is not block device interface.

I try to ask Dan Williams, Jan Kara, Christoph Hellwig and Hannes
Reineicke to help to review,
hope there are some experts may help to take a look.

Coly Li


