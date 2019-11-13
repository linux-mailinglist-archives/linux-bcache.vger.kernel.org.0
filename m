Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C843FBBCE
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Nov 2019 23:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfKMWn3 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 13 Nov 2019 17:43:29 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46031 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfKMWn3 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 13 Nov 2019 17:43:29 -0500
Received: by mail-pg1-f196.google.com with SMTP id k1so979469pgg.12
        for <linux-bcache@vger.kernel.org>; Wed, 13 Nov 2019 14:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BVWBmGhtDERtyI6f1PiSnPgkQq5kazk5WOyktt38THo=;
        b=G8ncn3oasagIyak0VBBLkjzbWfFemIt+6VJDeOZ/IQZ6uWDVADWm5+50NWya6OfXbS
         aMHuqq3bOsBP52kIM/60TzODUQ3UlP+xEEk+WHVLNlT8E4Gd8HaN9PYvdJizaEiOMYYi
         AheAEbn5av+s9LxQ+zfsb0lPzCoBDB//Q2SGnteTrxwimZ9XmvY6fBHCRktFXCsV+AU3
         yNq4cFDL7klVOoKYE78i5zC7Q0yxG5Ozg7diTClZsSYHTvOWjNE94EYUzWA4UjD5EhS2
         O+0QEvRlI+qZpeNYHDQj+Xbm1sPR1gDXfqZpsAWX3NQDes6tebUtvYer6SvdEPwDX/Mg
         ZqnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BVWBmGhtDERtyI6f1PiSnPgkQq5kazk5WOyktt38THo=;
        b=JXzUHBF6j5pSR3R94y41fU/3UUuG63PWwEK10GzaQE3TQ8ghMjG8QgWQH3cvKKKgOB
         pWnx1/o0OiDjRb/cc9ByBQ9/EpJ64t6G0fpArCWHXcSXZwyJUpqRTwhlmtKXV6I3/g/W
         4mZ+ceOG83B7suyPPwlQFsAqiQvUpKTZnOejDGFG4bPQO4ThDsvxC9KLrsv450Gqan1r
         9pa5aEuqIggPv4pXSilgYGTSB3hHeHCejdIFYAXe9llcgFXjR9xDdkOszgoeLVfmHSIO
         SuRkckf6pJVXyBgx77AA4eMb1dfRHHFRMzsp01DGXumF6DzmL3qdjLXnQoHeQ9KoAIU3
         oBaA==
X-Gm-Message-State: APjAAAVS36lWE089gesZF0gWHpTR3KWZbBe4E4HoqPFenR3G0R0CS05Q
        tYsZI6q+7NAJE3eXKzONF9T8/w==
X-Google-Smtp-Source: APXvYqzwhKQF4u390IbtLmhPZ2FdfvZUI459bhfTgyDpl0PehT0Kl4sVaQ8imrq07SOJ9YdasEh6og==
X-Received: by 2002:a17:90a:6d27:: with SMTP id z36mr8286844pjj.38.1573685007597;
        Wed, 13 Nov 2019 14:43:27 -0800 (PST)
Received: from [192.168.1.182] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id v16sm6352542pje.1.2019.11.13.14.43.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Nov 2019 14:43:26 -0800 (PST)
Subject: Re: [PATCH v2 00/12] bcache patches for Linux v5.5
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20191113080326.69989-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <201ace1c-78ba-89d6-74a0-55a254802e27@kernel.dk>
Date:   Wed, 13 Nov 2019 15:43:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191113080326.69989-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 11/13/19 1:03 AM, Coly Li wrote:
> Hi Jens,
> 
> The second submit adds two missed patches from Christoph Hellwig.
> 
> This is the patches for Linux v5.5. The patches have been testing for
> a while during my current development, they are ready to be merged.
> 
> There are still other patches under testing, I will submit to you in
> later runs if I feel they are solid enough in my testing.
> 
> Thanks for taking care of this.

Applied, thanks.

-- 
Jens Axboe

