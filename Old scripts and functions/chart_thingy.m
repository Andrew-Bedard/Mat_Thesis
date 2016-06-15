err = err_list;
err(err == 0) = -9999;
for i = 1:length(err(1,:));
er1 = err(:,i);
er1(er1 == -9999) = max(er1);
err(:,i) = er1;
end