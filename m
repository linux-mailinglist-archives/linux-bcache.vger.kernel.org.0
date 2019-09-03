Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5035BA6AD6
	for <lists+linux-bcache@lfdr.de>; Tue,  3 Sep 2019 16:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfICOJD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 3 Sep 2019 10:09:03 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:41909 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfICOJD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 3 Sep 2019 10:09:03 -0400
Received: by mail-io1-f65.google.com with SMTP id j5so36152933ioj.8
        for <linux-bcache@vger.kernel.org>; Tue, 03 Sep 2019 07:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DnQ6AaSqYo5ikPRrDlX6F1WW6RIy6QLGdJh3AvTo/vQ=;
        b=j5UDLT6hThq5I1A80/yAGtbsZqX/1x7/TlZOD/E97hi6BfhzitX3dsOAOw9p+nqtRU
         MtRILEcpj3FVsdwcNY7nXOqMxHaS8C7HunCsOLCUNqrgcyq09sAKCqo6hlOQ3XuB+STc
         A0VJ0N5mP4emNUgn7OQtpAbxn2w9hz61APQxwi6rxwbPFt9598wB6e+L7mSYKAuj1uug
         p0KyFWr8mivcxFxnAS8bVnyz7H0QnX4k3gkekAXmTL2olsATi8trYHqtQxzkfLj13Xyc
         73EkmUunLFsQNFxwmhEIc1cAvrI4fj8MaMDg3UWny0LU5G8Pi0bJScfHMA9GT83i4mcr
         lWuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DnQ6AaSqYo5ikPRrDlX6F1WW6RIy6QLGdJh3AvTo/vQ=;
        b=fATlMcaBYRHZ10cxnHBgsqv3epiIb79E8kHA3HHZD85Lga+uXR19yAGrhcFkYoPBIF
         6fJ1RAN4J3jKeDTQXwTEp+aSmSgn4Ws1izVKfs0g0ecdbNRJf5Vh2fDFBCzlC/DD9Gg4
         eH6zm480L0WT2+jXeFHevO6dYnLN93yagih43wOOYXyw2ZaPBdOl3KHGnmSYaa1syH3e
         NAJuDP+N8zuSA9vIk/mKORstzwTMF9e8taGToM8CVwEbAhnQoKA8DJroL2wPVIhXTyj4
         +5EjAtEP502bkpw/k65O2hTqsArTMjHqPpO6mC926mZM7vbrJBztcd4jOeeNIvdH96C0
         w2Xw==
X-Gm-Message-State: APjAAAWBiEyA/0c0jt5cukKk8qsX0FE0aIeC8+GMgqPdlKjxAqCzAoCR
        Qn5Qj9bv51DkVavZapSfXumzEd6jw4q0dg==
X-Google-Smtp-Source: APXvYqx7NRab0rE1lDaB7bRsYy+qrQ1hHD7Y4eAmA/OZ32s1EQx0dIdMKQQ8gDMxYYNa+StT2PxAvw==
X-Received: by 2002:a05:6638:1e5:: with SMTP id t5mr38292059jaq.79.1567519742045;
        Tue, 03 Sep 2019 07:09:02 -0700 (PDT)
Received: from [192.168.1.50] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d9sm13713604ioo.15.2019.09.03.07.09.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Sep 2019 07:09:01 -0700 (PDT)
Subject: Re: [PATCH 0/3] bcache patches for Linux v5.4
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
References: <20190903132545.30059-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0a1dddf5-c0c9-97a7-e41c-a1f937d62616@kernel.dk>
Date:   Tue, 3 Sep 2019 08:09:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190903132545.30059-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 9/3/19 7:25 AM, Coly Li wrote:
> Hi Jens,
> 
> Most of bcache development is still in progress now, for Linux v5.3
> we only have 3 patches to merge. Please take them.

Applied for 5.4, thanks.

-- 
Jens Axboe

